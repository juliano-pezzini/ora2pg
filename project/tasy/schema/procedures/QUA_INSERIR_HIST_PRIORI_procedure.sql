-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_inserir_hist_priori ( nm_usuario_p text, ds_relat_tec_p text, nr_seq_ordem_p bigint, ds_prio_new_p text, ds_prio_old_p text) AS $body$
DECLARE


			
ds_mensagem_w			varchar(4000);
ds_macro_w			varchar(4000);
ds_prio_new_w			varchar(4000);
ds_prio_old_w			varchar(4000);
nr_seq_idioma_w			bigint;


BEGIN

	if (ds_prio_new_p <> ds_prio_old_p) then
		begin
			select	coalesce(man_obter_idioma_os_local(nr_seq_ordem_p), 1)
			into STRICT	nr_seq_idioma_w
			;
			
			select	substr(obter_valor_dominio_idioma(1046,ds_prio_new_p, nr_seq_idioma_w), 1, 4000),
				substr(obter_valor_dominio_idioma(1046,ds_prio_old_p, nr_seq_idioma_w), 1, 4000)
			into STRICT	ds_prio_new_w,
				ds_prio_old_w
			;
			
			ds_macro_w	:=	substr('PRIORIDADE_ANTIGA='|| coalesce(ds_prio_old_w, ' ')
					||	';PRIORIDADE_NOVA=' || coalesce(ds_prio_new_w, ' ') 
					||	';JUSTIFICATIVA=' || ds_relat_tec_p, 1, 4000);
			
			ds_mensagem_w	:= substr(obter_texto_dic_objeto(686157, coalesce(nr_seq_idioma_w, 0), ds_macro_w),1,4000);
			
			begin
				insert into man_ordem_serv_tecnico(nr_sequencia,
						nr_seq_ordem_serv,
						dt_historico,
						dt_liberacao,
						nm_usuario,
						dt_atualizacao,
						nr_seq_tipo, 
						ds_relat_tecnico,
						nm_usuario_lib)
				values (	nextval('man_ordem_serv_tecnico_seq'),
						nr_seq_ordem_p,
						clock_timestamp(),
						clock_timestamp(), 
						nm_usuario_p,
						clock_timestamp(), 
						3, --Mudanca de prioridade
						ds_mensagem_w,
						nm_usuario_p);			
				commit;
			
			exception
			when others then	
				--Tratamento para nao disparar erro de FK  no cliente
				if (SQLSTATE <> -02291) then
					raise;
				end if;		
			end;				
		end;
	end if;																					
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_inserir_hist_priori ( nm_usuario_p text, ds_relat_tec_p text, nr_seq_ordem_p bigint, ds_prio_new_p text, ds_prio_old_p text) FROM PUBLIC;
