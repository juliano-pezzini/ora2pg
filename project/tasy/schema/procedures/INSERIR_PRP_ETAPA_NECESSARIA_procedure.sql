-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_prp_etapa_necessaria (nm_usuario_p text, nr_seq_tipo_projeto_p bigint, nr_seq_projeto_p bigint, nr_seq_etapa_p bigint) AS $body$
DECLARE


nr_seq_etapa_nec_w	bigint;


BEGIN

if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '')  and (nr_seq_etapa_p IS NOT NULL AND nr_seq_etapa_p::text <> '') then

	select	nextval('prp_etapa_necessaria_seq')
	into STRICT	nr_seq_etapa_nec_w
	;

	update	proj_projeto
	set	nr_seq_tipo_projeto = nr_seq_tipo_projeto_p
	where	nr_sequencia = nr_seq_projeto_p;

	insert into prp_etapa_necessaria(nr_sequencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					nr_seq_projeto,
					nr_seq_etapa_processo)
				values (nr_seq_etapa_nec_w,
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_p,
					nr_seq_projeto_p,
					nr_seq_etapa_p);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_prp_etapa_necessaria (nm_usuario_p text, nr_seq_tipo_projeto_p bigint, nr_seq_projeto_p bigint, nr_seq_etapa_p bigint) FROM PUBLIC;
