-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_integracao_protheus ( nr_seq_protocolo_p bigint, ie_acao_p bigint, nm_usuario_p text) AS $body$
DECLARE

/*
	ie_acao_p =>	1 - Indica que foi gerado o arquivo de integração
			2 - Indica que foi desfeito a geração do arquivo de integração
*/
nr_sequencia_w	protocolo_convenio_integr.nr_sequencia%type;


BEGIN

select	nextval('protocolo_convenio_integr_seq')
into STRICT	nr_sequencia_w
;

insert into protocolo_convenio_integr(
		nr_sequencia,
		nr_seq_protocolo,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_acao
) values (
		nr_sequencia_w,
		nr_seq_protocolo_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_acao_p
);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_integracao_protheus ( nr_seq_protocolo_p bigint, ie_acao_p bigint, nm_usuario_p text) FROM PUBLIC;

