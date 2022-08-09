-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_vinculo_soap ( nr_seq_soap_p bigint, ie_avaliacao_p text, nm_usuario_p text, cd_evolucao_p bigint default null) AS $body$
BEGIN

if (nr_seq_soap_p IS NOT NULL AND nr_seq_soap_p::text <> '') and (ie_avaliacao_p IS NOT NULL AND ie_avaliacao_p::text <> '') then
	if (cd_evolucao_p IS NOT NULL AND cd_evolucao_p::text <> '') then	-- Evolução
		insert into atendimento_soap_vinc(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_evolucao,
			nr_seq_soap,
			ie_avaliacao)
		values (
			nextval('atendimento_soap_vinc_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_evolucao_p,
			nr_seq_soap_p,
			ie_avaliacao_p);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_vinculo_soap ( nr_seq_soap_p bigint, ie_avaliacao_p text, nm_usuario_p text, cd_evolucao_p bigint default null) FROM PUBLIC;
