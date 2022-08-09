-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_obs_coleta_pend_js ( nr_sequencia_p text, nr_prescricao_p bigint, ds_observacao_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')then
	begin

	update 	prescr_procedimento
	set 	ds_observacao_coleta 	= ds_observacao_p
	where  	obter_se_contido(nr_sequencia ,(nr_sequencia_p)) = 'S'
	and    	nr_prescricao 		= nr_prescricao_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_obs_coleta_pend_js ( nr_sequencia_p text, nr_prescricao_p bigint, ds_observacao_p text) FROM PUBLIC;
