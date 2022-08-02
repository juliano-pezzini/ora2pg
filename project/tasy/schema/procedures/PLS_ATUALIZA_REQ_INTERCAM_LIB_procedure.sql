-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_req_intercam_lib ( nr_seq_requisicao_p bigint, cd_senha_externa_p text, dt_validade_senha_p timestamp, ds_historico_p text, nm_usuario_p text) AS $body$
DECLARE


ie_estagio_w			numeric(20);
qt_itens_neg_w			numeric(20);
qt_proc_neg_w			numeric(20);
qt_mat_neg_w			numeric(20);
qt_itens_aprov_w		numeric(20);
qt_proc_aprov_w			numeric(20);
qt_mat_aprov_w			numeric(20);


BEGIN

update	pls_requisicao_proc
set	ie_status		= 'P',
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	qt_procedimento		= qt_solicitado
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		= 'I';

update	pls_requisicao_mat
set	ie_status		= 'P',
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	qt_material		= qt_solicitado
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		= 'I';

select	count(1)
into STRICT	qt_proc_aprov_w
from	pls_requisicao_proc
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		= 'P';

select	count(1)
into STRICT	qt_mat_aprov_w
from	pls_requisicao_mat
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		= 'P';

qt_itens_aprov_w	:= qt_proc_aprov_w + qt_mat_aprov_w;

select	count(1)
into STRICT	qt_proc_neg_w
from	pls_requisicao_proc
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		= 'G';

select	count(1)
into STRICT	qt_mat_neg_w
from	pls_requisicao_mat
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		= 'G';

qt_itens_neg_w	:= qt_proc_neg_w + qt_mat_neg_w;

if (qt_itens_aprov_w	> 0) and (qt_itens_neg_w	> 0) then
	ie_estagio_w	:= 6;
elsif (qt_itens_aprov_w	> 0) and (qt_itens_neg_w	= 0) then
	ie_estagio_w	:= 2;
elsif (qt_itens_aprov_w	= 0) and (qt_itens_neg_w	> 0) then
	ie_estagio_w	:= 7;
end if;

update	pls_requisicao
set	ie_estagio		= ie_estagio_w,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	ds_observacao		= substr(ds_historico_p,1,4000),
	cd_senha_externa	= cd_senha_externa_p,
	dt_validade_senha	= dt_validade_senha_p,
	dt_valid_senha_ext	= dt_validade_senha_p,
	ie_req_interc_lib_manual	= 'S'
where	nr_sequencia		= nr_seq_requisicao_p;

CALL pls_requisicao_gravar_hist(	nr_seq_requisicao_p, 'L', substr('Realizada a liberação manual da requisição de intercâmbio nº '||nr_seq_requisicao_p||
				' pelo usuário '||nm_usuario_p||' em '||to_char(clock_timestamp() , 'dd/mm/yyyy hh24:mi:ss')||' com a seguinte justificativa: '||
				ds_historico_p,1,4000), null, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_req_intercam_lib ( nr_seq_requisicao_p bigint, cd_senha_externa_p text, dt_validade_senha_p timestamp, ds_historico_p text, nm_usuario_p text) FROM PUBLIC;

