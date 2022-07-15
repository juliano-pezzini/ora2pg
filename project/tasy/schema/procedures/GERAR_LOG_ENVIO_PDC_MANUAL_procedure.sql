-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_envio_pdc_manual ( nr_cot_compra_p bigint, nm_arquivo_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	agendamento_integracao a,
	log_integracao l,
	informacao_integracao i
where	a.nr_seq_log = l.nr_sequencia
and	l.nr_seq_informacao = i.nr_sequencia
and	i.nr_seq_evento = 92
and	a.ie_status = 'T'
and	a.ds_parametros like 'nr_cot_compra=' ||  nr_cot_compra_p || ';%';


BEGIN
insert into cot_compra_hist(
	nr_sequencia,
	nr_cot_compra,
	dt_atualizacao,
	nm_usuario,
	dt_historico,
	ds_titulo,
	ds_historico,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_origem,
	ie_tipo,
	dt_liberacao,
	nm_usuario_lib)
values (	nextval('cot_compra_hist_seq'),
	nr_cot_compra_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	wheb_mensagem_pck.get_texto(301635),
	substr(wheb_mensagem_pck.get_texto(301644, 'NM_ARQUIVO=' || nm_arquivo_p),1,4000),
	clock_timestamp(),
	nm_usuario_p,
	'S',
	'H',
	clock_timestamp(),
	nm_usuario_p);

open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	delete from agendamento_integracao
	where nr_sequencia = nr_sequencia_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_envio_pdc_manual ( nr_cot_compra_p bigint, nm_arquivo_p text, nm_usuario_p text) FROM PUBLIC;

