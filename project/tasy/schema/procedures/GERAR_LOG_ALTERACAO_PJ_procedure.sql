-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_alteracao_pj ( nm_usuario_p text, cd_cnpj_p text, ie_tipo_log_p text, vl_anterior_p text, vl_atual_p text) AS $body$
DECLARE


vl_anterior_w	varchar(255) := vl_anterior_p;
vl_atual_w	varchar(255) := vl_atual_p;


BEGIN
if (coalesce(vl_anterior_w,'X') = 'X') then
	vl_anterior_w := '';
end if;
if (coalesce(vl_atual_w,'X') = 'X') then
	vl_atual_w := '';
end if;
insert into pessoa_juridica_log(nr_sequencia,
				cd_cnpj,
				dt_atualizacao,
				dt_atualizacao_nrec,
				ie_tipo_log,
				nm_usuario,
				nm_usuario_nrec,
				vl_anterior,
				vl_atual)
			values (	nextval('pessoa_juridica_log_seq'),
				cd_cnpj_p,
				clock_timestamp(),
				clock_timestamp(),
				ie_tipo_log_p,
				nm_usuario_p,
				nm_usuario_p,
				vl_anterior_p,
				vl_atual_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_alteracao_pj ( nm_usuario_p text, cd_cnpj_p text, ie_tipo_log_p text, vl_anterior_p text, vl_atual_p text) FROM PUBLIC;
