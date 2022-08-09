-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_arq_disp_elet (nr_seq_equipamento_p bigint, ds_arquivo_p text, nm_usuario_p text, nr_seq_arquivo_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_arquivo_w	bigint;


BEGIN

select	nextval('w_arq_dispensario_auto_seq')
into STRICT	nr_seq_arquivo_w
;

insert into W_ARQ_DISPENSARIO_AUTO(nr_sequencia,
	nm_usuario,
	dt_atualizacao,
	nm_usuario_nrec,
	dt_atualizacao_nrec,
	ds_arquivo,
	nr_seq_equipamento,
	ie_lido)
values (nr_seq_arquivo_w,
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	ds_arquivo_p,
	nr_seq_equipamento_p,
	'N');

commit;


nr_seq_arquivo_p := nr_seq_arquivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_arq_disp_elet (nr_seq_equipamento_p bigint, ds_arquivo_p text, nm_usuario_p text, nr_seq_arquivo_p INOUT bigint) FROM PUBLIC;
