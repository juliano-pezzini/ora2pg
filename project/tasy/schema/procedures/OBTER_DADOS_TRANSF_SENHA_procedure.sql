-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_transf_senha (nr_atendimento_p bigint, cd_senha_gerada_p INOUT text, nr_seq_pac_senha_fila_p INOUT text, nr_seq_fila_espera_p INOUT text) AS $body$
DECLARE


cd_senha_gerada_w varchar(255) := '';
nr_seq_pac_senha_fila_w varchar(255) := '';
nr_seq_fila_espera_w varchar(255) := '';
				

BEGIN

if (coalesce(nr_atendimento_p,0) > 0) then

	SELECT	SUBSTR(MAX(obter_dados_senha(a.nr_seq_pac_senha_fila,'CD')),1,100) CD_SENHA_GERADA,
		MAX(a.nr_seq_pac_senha_fila) NR_SEQ_PAC_SENHA_FILA,
		SUBSTR(MAX(obter_dados_senha(a.nr_seq_pac_senha_fila,'SF')),1,100) NR_SEQ_FILA_ESPERA
	into STRICT 	cd_senha_gerada_w,
		nr_seq_pac_senha_fila_w,
		nr_seq_fila_espera_w     
	FROM atendimento_pa_js_v a
	WHERE a.nr_atendimento = nr_atendimento_p;
	
	if (coalesce(trim(both cd_senha_gerada_w)::text, '') = '') and (coalesce(trim(both nr_seq_pac_senha_fila_w)::text, '') = '') and (coalesce(trim(both nr_seq_fila_espera_w)::text, '') = '')then
	
		select	SUBSTR(MAX(obter_dados_senha(a.nr_seq_pac_senha_fila,'CD')),1,100) CD_SENHA_GERADA,
				max(NR_SEQ_PAC_SENHA_FILA) NR_SEQ_PAC_SENHA_FILA,
				SUBSTR(MAX(obter_dados_senha(a.nr_seq_pac_senha_fila,'SF')),1,100) NR_SEQ_FILA_ESPERA
		into STRICT 	cd_senha_gerada_w,
				nr_seq_pac_senha_fila_w,
				nr_seq_fila_espera_w
		from	agenda_consulta_v2 a
		where	nr_atendimento = nr_atendimento_p;
	
	end if;
	
cd_senha_gerada_p := cd_senha_gerada_w;
nr_seq_pac_senha_fila_p := nr_seq_pac_senha_fila_w;
nr_Seq_fila_espera_p := nr_seq_fila_espera_w;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_transf_senha (nr_atendimento_p bigint, cd_senha_gerada_p INOUT text, nr_seq_pac_senha_fila_p INOUT text, nr_seq_fila_espera_p INOUT text) FROM PUBLIC;

