-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpa_campos_documentacao (cd_cnpj_p text) AS $body$
BEGIN

if (coalesce(cd_cnpj_p,'-1') <> '-1') then
	update     pessoa_juridica
	set           cd_pf_resp_tecnico         = '',
		nr_registro_resp_tecnico   = '',
		dt_validade_resp_tecnico    = NULL,
		nr_alvara_sanitario        = '',
		dt_validade_alvara_sanit    = NULL,
		nr_alvara_sanitario_munic  = '',
		dt_validade_alvara_munic    = NULL,
		nr_certificado_boas_prat   = '',
		dt_validade_cert_boas_prat  = NULL,
		nr_autor_func              = '',
		dt_validade_autor_func      = NULL,
		nr_registro_pls            = '',
		nr_seq_cnae                 = NULL,
		nr_seq_nat_juridica         = NULL,
		ds_orgao_reg_resp_tecnico  = '',
		ds_resp_tecnico		   = '',
		nr_ccm			    = NULL,
		nr_cei			   = ''
	where   cd_cgc = cd_cnpj_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpa_campos_documentacao (cd_cnpj_p text) FROM PUBLIC;

