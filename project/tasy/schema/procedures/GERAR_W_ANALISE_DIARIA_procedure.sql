-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_analise_diaria ( dt_analise_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
nm_usuario_grupo_w       varchar(15);
nr_seq_grupo_w         bigint;
cd_pessoa_fisica_w       varchar(10);
qt_inicio_dia_w         bigint;
qt_recebida_w          bigint;
qt_recebida_ant_w        bigint;
qt_receb_usuario_w				bigint;
nm_usuario_w					varchar(15);
qt_final_dia_w         bigint;
nr_sequencia_w         bigint;
nr_seq_gerencia_w        bigint;
qt_total_executado_w		bigint;
dt_analise_hora_ant_w  timestamp;
dt_analise_hora_w        timestamp;
dt_analise_dia_w        timestamp;

C01 CURSOR FOR 
    SELECT nm_usuario_grupo, 
        Obter_Pessoa_Fisica_Usuario(nm_usuario_grupo,'C'), 
        nr_seq_grupo 
    from  usuario_grupo_des;

C02 CURSOR FOR 
    SELECT nr_sequencia, 
        nr_seq_gerencia 
    from  grupo_desenvolvimento 
    where  ie_situacao   = 'A';
		
C03 CURSOR FOR 
		SELECT count(distinct a.nr_sequencia), 
						substr(OBTER_NOME_USUARIO_EXEC_des(a.nr_sequencia, 'X'),1,30) nm_usuario 
				from  man_ordem_servico a 
				where  nr_seq_grupo_des	= nr_seq_grupo_w 
				and (SELECT min(b.dt_atualizacao) 
						from  	man_estagio_processo c, 
								man_ordem_serv_estagio b 
						where  a.nr_sequencia     = b.nr_seq_ordem 
						and   b.nr_seq_estagio    = c.nr_sequencia 
						and   c.ie_desenv       = 'S') between 
					dt_analise_hora_w - 3/24 and dt_analise_hora_w;
						

BEGIN 
 
dt_analise_hora_w        := trunc(dt_analise_p, 'hh24');
dt_analise_dia_w        := trunc(dt_analise_p);
 
delete from w_analise_diaria 
where  dt_analise = dt_analise_dia_w;
 
delete from w_analise_diaria_hora 
where  dt_analise = dt_analise_hora_w;
 
select max(dt_analise) 
into STRICT  dt_analise_hora_ant_w 
from  w_analise_diaria_hora 
where  dt_analise < dt_analise_hora_w 
and       dt_analise between trunc(dt_analise_dia_w) and fim_dia(dt_analise_dia_w);
 
commit;
 
open C01;
loop 
fetch C01 into 
    nm_usuario_grupo_w, 
    cd_pessoa_fisica_w, 
    nr_seq_grupo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
    begin 
 
    select nr_seq_gerencia 
    into STRICT  nr_seq_gerencia_w 
    from  grupo_desenvolvimento 
    where  nr_sequencia  = nr_seq_grupo_w;
 
    select coalesce(max(qt_final_dia),0) 
    into STRICT  qt_inicio_dia_w 
    from  w_analise_diaria 
    where  dt_analise       = dt_analise_dia_w - 1 
    and   cd_pessoa_fisica    = cd_pessoa_fisica_w;
 
    select count(*) 
    into STRICT  qt_recebida_w 
    from  man_ordem_servico_exec a 
    where  a.dt_recebimento between trunc(dt_analise_dia_w) and fim_dia(dt_analise_dia_w) 
    and   a.nm_usuario_exec    = nm_usuario_grupo_w 
    and exists (  SELECT 1 
            from  man_estagio_processo c, 
                man_ordem_serv_estagio b 
            where  a.nr_seq_ordem     = b.nr_seq_ordem 
            and   b.nr_seq_estagio    = c.nr_sequencia 
            and   c.ie_desenv       = 'S');
 
    select count(*) 
    into STRICT  qt_final_dia_w 
    from  man_ordem_servico_exec b, 
      man_estagio_processo c, 
        man_ordem_servico a 
    where  a.nr_seq_estagio    = c.nr_sequencia 
    and   c.ie_desenv       = 'S' 
		and   b.nr_seq_ordem     = a.nr_sequencia 
		and   b.nm_usuario_exec    = nm_usuario_grupo_w 
		and   b.nm_usuario_exec    = 
				(SELECT max(x.nm_usuario_exec) 
         from  usuario_grupo_des y, 
						 man_ordem_servico_exec x 
            where  x.nr_seq_ordem     = a.nr_sequencia 
				and	x.nm_usuario_exec	= y.nm_usuario_grupo);
				 
				 
		/*select	count(*) 
		into  qt_final_dia_w 
		from  man_ordem_servico_v a 
		where  a.nr_seq_meta_pe is null 
		and   a.nr_seq_obj_bsc is null 
		and   (a.NR_GRUPO_TRABALHO in ( select  a.nr_sequencia 
               from   man_grupo_trabalho a, 
                    man_grupo_trab_usuario b 
               where  a.nr_sequencia = b.nr_seq_grupo_trab 
               and   b.nm_usuario_param = nm_usuario_grupo_w)) 
		and   a.ie_status_ordem in ('1','2') 
		and   a.nm_usuario_exec_prev = nm_usuario_grupo_w 
		and   a.nr_seq_estagio in (select  nr_seq_estagio 
               from   man_estagio_usuario 
               where  nm_usuario_acao = nm_usuario_grupo_w) 
		and   a.nr_seq_grupo_des = nr_seq_grupo_w;*/
 
				 
 
    select nextval('w_analise_diaria_seq') 
    into STRICT  nr_sequencia_w 
;
 
    insert into w_analise_diaria( 
        nr_sequencia, 
        dt_atualizacao, 
        nm_usuario, 
        dt_atualizacao_nrec, 
        nm_usuario_nrec, 
        nr_seq_gerencia, 
        nr_seq_grupo_des, 
        cd_pessoa_fisica, 
        dt_analise, 
        qt_inicio_dia, 
        qt_recebida, 
        qt_final_dia) 
    values ( nr_sequencia_w, 
        clock_timestamp(), 
        nm_usuario_p, 
        clock_timestamp(), 
        nm_usuario_p, 
        nr_seq_gerencia_w, 
        nr_seq_grupo_w, 
        cd_pessoa_fisica_w, 
        dt_analise_dia_w, 
        qt_inicio_dia_w, 
        qt_recebida_w, 
        qt_final_dia_w);
 
    if (to_char(dt_analise_hora_w, 'hh24') in ('00', '09','12','15','18')) then 
        begin 
				 
				qt_recebida_w	:= 0;
				 
				/*open C03; 
				loop 
				fetch C03 into	 
						qt_receb_usuario_w, 
						nm_usuario_w; 
				exit when C01%notfound; 
					begin 
					 
					if	(nm_usuario_w	= nm_usuario_grupo_w) then 
						qt_recebida_w	:= qt_recebida_w + qt_receb_usuario_w; 
					end if; 
					end; 
				end loop; 
				close C03; 
			*/
 
				if (to_char(dt_analise_hora_w, 'hh24') in ('09')) then 
					select count(*) 
					into STRICT  qt_recebida_w 
					from  man_ordem_servico_exec a 
					where  a.dt_recebimento between trunc(dt_analise_hora_w, 'dd') and dt_analise_hora_w 
					and   a.nm_usuario_exec    = nm_usuario_grupo_w 
					and exists (  SELECT 1 
	            from  man_estagio_processo c, 
	                man_ordem_serv_estagio b 
	            where  a.nr_seq_ordem     = b.nr_seq_ordem 
	            and   b.nr_seq_estagio    = c.nr_sequencia 
	            and   c.ie_desenv       = 'S');
				else 
					select count(*) 
					into STRICT  qt_recebida_w 
					from  man_ordem_servico_exec a 
					where  a.dt_recebimento between dt_analise_hora_w - 3/24 and dt_analise_hora_w 
					and   a.nm_usuario_exec    = nm_usuario_grupo_w 
					and exists (  SELECT 1 
	            from  man_estagio_processo c, 
	                man_ordem_serv_estagio b 
	            where  a.nr_seq_ordem     = b.nr_seq_ordem 
	            and   b.nr_seq_estagio    = c.nr_sequencia 
	            and   c.ie_desenv       = 'S');
				end if;
				 
				select 	count(distinct b.nr_seq_ordem) 
				into STRICT	qt_total_executado_w 
				from 	man_estagio_processo d, 
						usuario_grupo_des c, 
						man_ordem_servico a, 
						man_ordem_serv_estagio b 
				where 	a.nr_sequencia = b.nr_seq_ordem 
				and 	a.nr_seq_grupo_des = nr_seq_grupo_w 
				and 	c.nr_seq_grupo = a.nr_seq_grupo_des 
				and 	b.nr_seq_estagio = d.nr_sequencia 
				and 	((d.ie_suporte = 'S') or (d.nr_sequencia in (2,811,511,1511))) 
				and 	c.nm_usuario_grupo = b.nm_usuario 
				and 	c.nm_usuario_grupo = nm_usuario_grupo_w 
				and 	b.dt_atualizacao between dt_analise_hora_ant_w and dt_analise_hora_w;				
				 
				 
        select nextval('w_analise_diaria_hora_seq') 
        into STRICT  nr_sequencia_w 
;
 
        insert into w_analise_diaria_hora( 
            nr_sequencia, 
            dt_atualizacao, 
            nm_usuario, 
            dt_atualizacao_nrec, 
            nm_usuario_nrec, 
            nr_seq_gerencia, 
            nr_seq_grupo_des, 
            cd_pessoa_fisica, 
            dt_analise, 
            qt_inicio_dia, 
            qt_recebida, 
            qt_final_dia, 
						qt_total_executado) 
        values ( nr_sequencia_w, 
            clock_timestamp(), 
            nm_usuario_p, 
            clock_timestamp(), 
            nm_usuario_p, 
            nr_seq_gerencia_w, 
            nr_seq_grupo_w, 
            cd_pessoa_fisica_w, 
            dt_analise_hora_w, 
            qt_inicio_dia_w, 
            qt_recebida_w, 
            qt_final_dia_w, 
						qt_total_executado_w);
 
        end;
    end if;
 
    end;
end loop;
close C01;
 
open C02;
loop 
fetch C02 into 
    nr_seq_grupo_w, 
    nr_seq_gerencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
    begin 
    select coalesce(max(qt_final_dia),0) 
    into STRICT  qt_inicio_dia_w 
    from  w_analise_diaria 
    where  dt_analise       = dt_analise_dia_w - 1 
    and   coalesce(cd_pessoa_fisica::text, '') = '' 
    and   nr_seq_grupo_des    = nr_seq_grupo_w;
 
    select count(*) 
    into STRICT  qt_recebida_w 
    from  man_ordem_servico a 
    where  a.nr_seq_grupo_des   = nr_seq_grupo_w 
    and   trunc(dt_analise_dia_w)   = (   SELECT trunc(min(b.dt_atualizacao)) 
                        from  man_estagio_processo c, 
                            man_ordem_serv_estagio b 
                        where  a.nr_sequencia     = b.nr_seq_ordem 
                        and   b.nr_seq_estagio    = c.nr_sequencia 
                        and   c.ie_desenv       = 'S');
 
	select	sum(qt_ordem) 
    into STRICT  qt_final_dia_w 
	from ( 
    SELECT sum(CASE WHEN obter_se_ordem_vinc_projeto(a.nr_sequencia,'1')='S' THEN  1  ELSE 0 END  + 
					CASE WHEN obter_se_ordem_vinc_projeto(a.nr_sequencia,'2')='N' THEN  1  ELSE 0 END ) qt_ordem 
    from  grupo_desenvolvimento d, 
		man_estagio_processo c, 
        man_ordem_servico a 
    where  a.nr_seq_estagio    = c.nr_sequencia 
    and   c.ie_desenv       = 'S' 
	and   coalesce(a.nr_seq_meta_pe::text, '') = '' 
	and   coalesce(a.nr_seq_obj_bsc::text, '') = '' 
	and   a.ie_status_ordem in ('1','2') 
    and   a.nr_seq_grupo_des   = nr_seq_grupo_w 
	and	a.nr_seq_grupo_des	= d.nr_sequencia 
	and	d.nr_seq_gerencia	<> 7 
	
union
 
	SELECT count(*) 
    from  grupo_desenvolvimento d, 
		man_estagio_processo c, 
        man_ordem_servico a 
    where  a.nr_seq_estagio    = c.nr_sequencia 
    and   c.ie_desenv       = 'S' 
	and   coalesce(a.nr_seq_meta_pe::text, '') = '' 
	and   coalesce(a.nr_seq_obj_bsc::text, '') = '' 
	and   a.ie_status_ordem in ('1','2') 
    and   a.nr_seq_grupo_des   = nr_seq_grupo_w 
	and	a.nr_seq_grupo_des	= d.nr_sequencia 
	and	d.nr_seq_gerencia	= 7) alias11;
 
    select nextval('w_analise_diaria_seq') 
    into STRICT  nr_sequencia_w 
;
 
    insert into w_analise_diaria( 
        nr_sequencia, 
        dt_atualizacao, 
        nm_usuario, 
        dt_atualizacao_nrec, 
        nm_usuario_nrec, 
        nr_seq_gerencia, 
        nr_seq_grupo_des, 
        cd_pessoa_fisica, 
        dt_analise, 
        qt_inicio_dia, 
        qt_recebida, 
        qt_final_dia) 
    values ( nr_sequencia_w, 
        clock_timestamp(), 
        nm_usuario_p, 
        clock_timestamp(), 
        nm_usuario_p, 
        nr_seq_gerencia_w, 
        nr_seq_grupo_w, 
        null, 
        dt_analise_dia_w, 
        qt_inicio_dia_w, 
        qt_recebida_w, 
        qt_final_dia_w);
 
    if (to_char(dt_analise_hora_w, 'hh24') in ('00', '09','12','15','18')) then 
        begin 
 
        select nextval('w_analise_diaria_hora_seq') 
        into STRICT  nr_sequencia_w 
;
 
        select max(qt_recebida) 
        into STRICT  qt_recebida_ant_w 
        from  w_analise_diaria_hora 
        where  dt_analise       = dt_analise_hora_ant_w 
        and   nr_seq_grupo_des    = nr_seq_grupo_w;
 
 
		select 	count(distinct b.nr_seq_ordem) 
		into STRICT	qt_total_executado_w 
		from 	man_estagio_processo d, 
   			usuario_grupo_des c, 
   			man_ordem_servico a, 
   			man_ordem_serv_estagio b 
		where 	a.nr_sequencia = b.nr_seq_ordem 
		and 	a.nr_seq_grupo_des = nr_seq_grupo_w 
		and 	c.nr_seq_grupo = a.nr_seq_grupo_des 
		and 	b.nr_seq_estagio = d.nr_sequencia 
		and 	((d.ie_suporte = 'S') or (d.nr_sequencia in (2,811,511,1511))) 
		and 	c.nm_usuario_grupo = b.nm_usuario 
		and 	b.dt_atualizacao between dt_analise_hora_ant_w and dt_analise_hora_w;
 
 
 
        insert into w_analise_diaria_hora( 
            nr_sequencia, 
            dt_atualizacao, 
            nm_usuario, 
            dt_atualizacao_nrec, 
            nm_usuario_nrec, 
            nr_seq_gerencia, 
            nr_seq_grupo_des, 
            cd_pessoa_fisica, 
            dt_analise, 
            qt_inicio_dia, 
            qt_recebida, 
            qt_final_dia, 
			qt_total_executado) 
        values ( nr_sequencia_w, 
            clock_timestamp(), 
            nm_usuario_p, 
            clock_timestamp(), 
            nm_usuario_p, 
            nr_seq_gerencia_w, 
            nr_seq_grupo_w, 
            null, 
            dt_analise_hora_w, 
            qt_inicio_dia_w, 
            qt_recebida_w - coalesce(qt_recebida_ant_w,0), 
            qt_final_dia_w, 
			qt_total_executado_w);
        end;
    end if;
 
    end;
end loop;
close C02;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_analise_diaria ( dt_analise_p timestamp, nm_usuario_p text) FROM PUBLIC;
