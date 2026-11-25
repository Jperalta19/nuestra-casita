begin;
create table if not exists public.nc_hogares_v14 (jugador uuid primary key references public.jugadores(id), casa uuid not null references public.casas(id));
alter table public.nc_hogares_v14 enable row level security;
revoke all on public.nc_hogares_v14 from public, anon, authenticated;
create function public.nc_v14_residencia(p_token text) returns jsonb language plpgsql security definer set search_path='' as $$
declare j uuid:=public.nc_identidad(p_token); c uuid; o uuid; begin
select casa into c from public.miembros where jugador=j;
select casa into o from public.nc_hogares_v14 where jugador=j;
return jsonb_build_object('compartida',o is not null and c is distinct from o);
end;$$;
create function public.nc_v14_mudar(p_token text,p_codigo text default null) returns boolean language plpgsql security definer set search_path='' as $$
declare j uuid:=public.nc_identidad(p_token); actual uuid; destino uuid; propia uuid; d integer; begin
perform 1 from public.jugadores where id=j for update;
select casa into actual from public.miembros where jugador=j;
if actual is null then perform public.nc_crear(p_token); select casa into actual from public.miembros where jugador=j; end if;
select casa into propia from public.nc_hogares_v14 where jugador=j;
if propia is null then propia:=actual; end if;
if p_codigo is null then destino:=propia; else select id into destino from public.casas where codigo=upper(trim(p_codigo)); end if;
if destino is null then raise exception 'Código de casa inválido.'; end if;
perform 1 from public.casas where id in(actual,destino) order by id for update;
if exists(select 1 from public.miembros where jugador=j and accion is not null) then raise exception 'Termina tu actividad antes de mudarte.'; end if;
if destino<>actual and (select count(*) from public.miembros where casa=destino)>=2 then raise exception 'La casa ya tiene dos personas.'; end if;
insert into public.nc_hogares_v14(jugador,casa) values(j,propia) on conflict(jugador) do nothing;
select dia into d from public.casas where id=destino;
update public.miembros set casa=destino,x=0,z=0,dia=d,pos_actualizada=now(),actualizado=now() where jugador=j;
return true; end;$$;
create function public.nc_v14_personaje(p_token text,p_personaje jsonb) returns boolean language plpgsql security definer set search_path='' as $$
declare j uuid:=public.nc_identidad(p_token); begin
if coalesce(p_personaje->>'calzado','zapatos') not in ('zapatos','tenis') then raise exception 'Calzado inválido.'; end if;
perform public.nc_personaje(p_token,p_personaje);
update public.jugadores set personaje=personaje||jsonb_build_object('calzado',coalesce(p_personaje->>'calzado','zapatos')) where id=j;
return true; end;$$;
revoke all on function public.nc_v14_residencia(text),public.nc_v14_mudar(text,text),public.nc_v14_personaje(text,jsonb) from public;
grant execute on function public.nc_v14_residencia(text),public.nc_v14_mudar(text,text),public.nc_v14_personaje(text,jsonb) to anon,authenticated;
commit;
