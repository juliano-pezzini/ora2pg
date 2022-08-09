-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_man_ordem_serv_prio ( nr_seq_ordem_p bigint, ie_prioridade_p text, ie_prioridade_antiga_p text, nr_seq_justif_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


ds_observacao_w			varchar(255);
ds_prioridade_w			varchar(255);
ds_prioridade_antiga_w		varchar(255);
ds_macro_w			varchar(4000);
nr_seq_idioma_w			bigint;


BEGIN

	if (ie_prioridade_p <> ie_prioridade_antiga_p) then
		begin

			select	coalesce(man_obter_idioma_os_local(nr_seq_ordem_p), 1)
			into STRICT	nr_seq_idioma_w
			;
			
			select	substr(obter_valor_dominio(1046,ie_prioridade_p), 1, 255),
				substr(obter_valor_dominio(1046,ie_prioridade_antiga_p), 1, 255)
			into STRICT	ds_prioridade_w,
				ds_prioridade_antiga_w
			;
			
			ds_macro_w	:=	substr('PRIORIDADE_ANTIGA='|| coalesce(ds_prioridade_antiga_w, '')
					||	';PRIORIDADE_NOVA=' || coalesce(ds_prioridade_w, '') 
					||	';JUSTIFICATIVA=' || ds_observacao_p, 1, 4000);
			
			select	substr(obter_desc_exp_idioma(742190, nr_seq_idioma_w, ds_macro_w), 1, 255)
			into STRICT	ds_observacao_w
			;
	
			insert into man_ordem_serv_prio(
				nr_sequencia,
				nr_seq_ordem,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_prioridade,
				nr_seq_justif,
				ds_observacao)
			values (	nextval('man_ordem_serv_prio_seq'),
				nr_seq_ordem_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ie_prioridade_p,
				nr_seq_justif_p,
				ds_observacao_w);
			
			commit;
		end;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_man_ordem_serv_prio ( nr_seq_ordem_p bigint, ie_prioridade_p text, ie_prioridade_antiga_p text, nr_seq_justif_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
