-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ajusta_relatorio_swing_pck.grava_erro (ds_erro_p text, ie_impeditivo_p text) AS $body$
DECLARE

	current_setting('ajusta_relatorio_swing_pck.ds_erro_w')::varchar(4000)	varchar(4000);
	
BEGIN
		PERFORM set_config('ajusta_relatorio_swing_pck.ds_erro_w', substr(ds_erro_p,1,4000), false);
		insert into log_erro_relatorio(
			nr_seq_relatorio,
			nr_seq_banda,
			nr_seq_campo,
			nr_seq_parametro,
			ds_erro,
			ie_impeditivo
		) values (
			current_setting('ajusta_relatorio_swing_pck.nr_seq_relatorio_w')::bigint,
			current_setting('ajusta_relatorio_swing_pck.nr_seq_banda_w')::bigint,
			current_setting('ajusta_relatorio_swing_pck.nr_seq_campo_w')::bigint,
			current_setting('ajusta_relatorio_swing_pck.nr_seq_parametro_w')::bigint,
			current_setting('ajusta_relatorio_swing_pck.ds_erro_w')::varchar(4000),
			ie_impeditivo_p
		);
		commit;
	end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE ajusta_relatorio_swing_pck.grava_erro (ds_erro_p text, ie_impeditivo_p text) FROM PUBLIC;