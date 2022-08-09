-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reverter_consentimento (nr_seq_consentimento_p bigint) AS $body$
BEGIN

	update pep_pac_ci set ie_status = 'P',
		ds_just_recusa  = NULL,
		nm_usuario_status  = NULL,
		dt_aceite_recusa  = NULL,
    		ie_assinado  = NULL,
    		nr_seq_relat_received_expl  = NULL,
    		ds_representante  = NULL,
    		nr_cartao_nac_sus  = NULL,
    		nr_cpf  = NULL
	where nr_sequencia = nr_seq_consentimento_p;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reverter_consentimento (nr_seq_consentimento_p bigint) FROM PUBLIC;
