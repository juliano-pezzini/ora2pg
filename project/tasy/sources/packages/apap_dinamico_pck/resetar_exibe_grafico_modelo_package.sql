-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE apap_dinamico_pck.resetar_exibe_grafico_modelo (nr_atendimento_p bigint, nr_seq_documento_p bigint) AS $body$
BEGIN
		update w_apap_pac_informacao
		set ie_exibe_grafico = 'N'
		where nr_seq_apap_grupo in (
			SELECT a.nr_sequencia
			  from w_apap_pac_grupo a
			 inner join w_apap_pac b
				on a.nr_seq_mod_apap = b.nr_sequencia
			 where b.nr_seq_documento = nr_seq_documento_p
			   and b.nr_atendimento = nr_atendimento_p
		);

		commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apap_dinamico_pck.resetar_exibe_grafico_modelo (nr_atendimento_p bigint, nr_seq_documento_p bigint) FROM PUBLIC;