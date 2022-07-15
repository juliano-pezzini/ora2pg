-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_obter_proxima_os_prev (nm_usuario_p text) AS $body$
DECLARE

 
qt_ordem_dia_w		bigint;
nr_sequencia_w		bigint := 0;
qt_ordem_futura_w		bigint;
qt_dia_w			bigint := 0;
ie_base_corp_w		varchar(1);
ie_buscou_os_w		varchar(1) := 'N';
qt_registro_w		bigint;
nr_seq_ordem_serv_w	bigint;
ds_ordem_serv_pend_w	varchar(255);
nr_length_w	bigint;

 
C01 CURSOR FOR 
	SELECT 	nr_seq_ordem_serv 
	from	man_ordem_servico_v a, 
		man_ordem_ativ_prev b 
	where	a.nr_sequencia = b.nr_seq_ordem_serv 
	and	((coalesce(a.nr_seq_gerencia_des,0) <> 60) or (coalesce(a.nr_seq_estagio,0) <> 261)) 
	and	coalesce(b.dt_real::text, '') = '' 
	and	b.nm_usuario_prev = nm_usuario_p 
	and	trunc(b.dt_prevista,'dd')	= trunc(clock_timestamp(),'dd');


BEGIN 
begin 
select	count(*) 
into STRICT	qt_ordem_dia_w 
from	man_ordem_servico_v a, 
	man_ordem_ativ_prev b 
where	a.nr_sequencia = b.nr_seq_ordem_serv 
and	((coalesce(a.nr_seq_gerencia_des,0) <> 60) or (coalesce(a.nr_seq_estagio,0) <> 261)) 
and	coalesce(b.dt_real::text, '') = '' 
and	b.nm_usuario_prev = nm_usuario_p 
and	trunc(b.dt_prevista,'dd')	= trunc(clock_timestamp(),'dd');
exception 
when others then 
	qt_ordem_dia_w := 0;
end;
 
if (qt_ordem_dia_w = 0) then 
	begin 
	ie_base_corp_w	:=	coalesce(obter_se_base_corp,'N');
	 
	if (ie_base_corp_w = 'S') then 
		begin 
		select 	count(*) 
		into STRICT	qt_registro_w 
		from	lista_usuario_os 
		where	nm_usuario_lista = nm_usuario_p 
		and	ie_situacao	= 'A';
		 
		if (qt_registro_w > 0) then 
			begin 
			CALL exec_sql_dinamico('','begin fila_busca_nova_os('|| chr(39) || nm_usuario_p || chr(39) || ', 0);end;');
			 
			begin 
			select	count(*) 
			into STRICT	qt_ordem_dia_w 
			from	man_ordem_ativ_prev 
			where	coalesce(dt_real::text, '') = '' 
			and	nm_usuario_prev = nm_usuario_p 
			and	trunc(dt_prevista,'dd')	= trunc(clock_timestamp(),'dd');
			exception 
			when others then 
				qt_ordem_dia_w := 0;
			end;
			end;
		end if;		
		end;
	end if;	
	 
	if (qt_ordem_dia_w > 0) then 
		ie_buscou_os_w	:= 'S';
	end if;
	exception 
	when others then 
		ie_base_corp_w	:=	'N';	
	end;
end if;
 
if (qt_ordem_dia_w = 0) then 
	begin 
	 
	begin 
	select	count(*) 
	into STRICT	qt_ordem_futura_w 
	from	man_ordem_ativ_prev a 
	where	a.nm_usuario_prev = nm_usuario_p 
	and	a.dt_prevista > clock_timestamp() 
	and	coalesce(a.dt_real::text, '') = '';
	exception 
	when others then 
		qt_ordem_futura_w := 0;
	end;
	 
	if (coalesce(qt_ordem_futura_w,0) > 0) then 
		begin 
		while(coalesce(nr_sequencia_w,0) = 0) loop 
			begin 
			 
			qt_dia_w := qt_dia_w + 1;
			 
			select	coalesce(min(a.nr_sequencia),0) 
			into STRICT	nr_sequencia_w 
			from	man_ordem_ativ_prev a 
			where	a.nm_usuario_prev = nm_usuario_p 
			and	trunc(a.dt_prevista,'dd') = trunc(clock_timestamp() + qt_dia_w,'dd') 
			and	coalesce(a.dt_real::text, '') = '' 
			and	a.ie_prioridade_desen = (SELECT max(ie_prioridade_desen) 
							from	man_ordem_ativ_prev x 
							where	x.nm_usuario_prev 	= a.nm_usuario_prev 
							and	x.dt_prevista		= a.dt_prevista 
							and	coalesce(x.dt_real::text, '') = '');
					 
			if (coalesce(nr_sequencia_w,0) > 0) then 
				begin 
		 
				begin 
				update	man_ordem_ativ_prev 
				set	dt_prevista	= clock_timestamp(), 
					nm_usuario	= nm_usuario_p, 
					dt_atualizacao	= clock_timestamp(), 
					ie_fora_planej_diario = 'S' 
				where	nr_sequencia	= nr_sequencia_w;				
				exception 
				when others then 
					CALL wheb_mensagem_pck.exibir_mensagem_abort(262006); -- não foi possível obter a próxima ordem de serviço. 
				end;
		 
				end;
			end if;
			 
			end;
		end loop;
		end;
	else 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(262007); -- não foi possível obter a próxima os! (enter) não foram encontradas ordens previstas para este executor 
	end if;
	 
	end;
elsif (ie_buscou_os_w = 'N') then 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_ordem_serv_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_ordem_serv_pend_w	:= nr_seq_ordem_serv_w||', '||ds_ordem_serv_pend_w;
		end;
	end loop;
	close C01;
	nr_length_w	:= length(ds_ordem_serv_pend_w);
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262008,'DS_OS_PEND=' || substr(ds_ordem_serv_pend_w,1,nr_length_w -2));
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_obter_proxima_os_prev (nm_usuario_p text) FROM PUBLIC;

