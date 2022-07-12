-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_avaliacoes_pendentes ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w					varchar(4000);


BEGIN

SELECT	obter_select_concatenado_bv('SELECT	b.ds_tipo FROM 	med_avaliacao_paciente a, med_TIPO_AVALIACAO b WHERE dt_liberacao IS NULL
											AND a.nr_atendimento = :nr_atendimento AND	a.nr_seq_tipo_avaliacao = b.nr_sequencia',
									'nr_atendimento='||nr_atendimento_p||';', '; ')
INTO STRICT		 ds_retorno_w
;
RETURN 		 ds_retorno_w;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_avaliacoes_pendentes ( nr_atendimento_p bigint) FROM PUBLIC;
