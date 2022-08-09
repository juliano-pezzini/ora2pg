-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_gerar_anexo_ii ( nr_seq_lote_sip_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estrutura_sip_w		varchar(40);
ds_estrutura_sip_w		varchar(80);
ie_tipo_beneficiario_w		varchar(3);
ie_tipo_plano_w			varchar(3);
qt_eventos_proc_w		bigint	:= 0;
vl_despesa_w			double precision	:= 0;
vl_glosa_w			double precision	:= 0;
dt_periodo_inicial_w		timestamp;
dt_periodo_final_w		timestamp;
ie_ind_familiar_w		varchar(1);
ie_coletivo_sem_patro_w		varchar(1);
ie_coletivo_com_patro_w		varchar(1);
ie_expostos_w			varchar(1);
ie_eventos_w			varchar(1);
ie_total_despesa_w		varchar(1);
ie_coparticipacao_w		varchar(1);
ie_seguros_w			varchar(1);

C01 CURSOR FOR
	/* Procedimento contas médicas */

	SELECT	cd_estrutura_sip,
		ie_tipo_beneficiario, /* Dom 1923 */
		ie_tipo_plano, /* Dom 2213 */
		coalesce(sum(qt_item),0),
		coalesce(sum(vl_despesa),0) vl_despesa,
		coalesce(sum(vl_glosa),0) vl_glosa
	from	sip_resumo_conta
	where	dt_item between dt_periodo_inicial_w and dt_periodo_final_w
	and	coalesce(ie_tipo_segurado,'B')	= 'B'
	group by
		cd_estrutura_sip,
		ie_tipo_beneficiario,
		ie_tipo_plano;



BEGIN

CALL sip_calcular_nr_expostos(nr_seq_lote_sip_p, nm_usuario_p);

begin
select	dt_periodo_inicial,
	coalesce(dt_periodo_final, clock_timestamp()),
	ie_ind_familiar,
	ie_coletivo_sem_patroci,
	ie_coletivo_com_patroci
into STRICT	dt_periodo_inicial_w,
	dt_periodo_final_w,
	ie_ind_familiar_w,
	ie_coletivo_sem_patro_w,
	ie_coletivo_com_patro_w
from	pls_lote_sip
where	nr_sequencia	= nr_seq_lote_sip_p;
exception
	when others then
	ie_ind_familiar_w	:= 'N';
	ie_coletivo_sem_patro_w	:= 'N';
	ie_coletivo_com_patro_w	:= 'N';
	CALL wheb_mensagem_pck.exibir_mensagem_abort('Problema na leitura dos dados do lote SIP (' || nr_seq_lote_sip_p || ')');
end;

/*delete from logxxxxx_tasy where cd_log = 2008;*/

open C01;
loop
fetch C01 into
	cd_estrutura_sip_w,
	ie_tipo_beneficiario_w,
	ie_tipo_plano_w,
	qt_eventos_proc_w,
	vl_despesa_w,
	vl_glosa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/* Obter dados da estrutura SIP do procedimento */

	begin
	select	coalesce(ds_estrutura,''),
		coalesce(ie_expostos,'S'),
		coalesce(ie_eventos,'S'),
		coalesce(ie_total_despesa,'S'),
		coalesce(ie_coparticipacao,'S'),
		coalesce(ie_seguros,'S')
	into STRICT	ds_estrutura_sip_w,
		ie_expostos_w,
		ie_eventos_w,
		ie_total_despesa_w,
		ie_coparticipacao_w,
		ie_seguros_w
	from	sip_estrutura_proc
	where	ie_situacao	= 'A'
	and	cd_estrutura	= cd_estrutura_sip_w;
	exception
		when others then
		ds_estrutura_sip_w	:= '';
	end;

	/* Tratamento feito para verificar se o item não possui valor de despesa então não pode ter Nº de eventos, isso porque não encaixou em nenhuma regra do SIP  das contas comtábeis*/

	if (vl_despesa_w	= 0) then
		qt_eventos_proc_w	:= 0;
	end if;

	/* Gravar os dados lidos */

	CALL sip_gravar_item_despesa(null, null, null,
			cd_estrutura_sip_w, 0, qt_eventos_proc_w,
			vl_despesa_w, 0, 0,
			nr_seq_lote_sip_p, ie_tipo_plano_w, ds_estrutura_sip_w,
			ie_tipo_beneficiario_w, ie_expostos_w, ie_eventos_w,
			ie_total_despesa_w, ie_coparticipacao_w, ie_seguros_w,
			0, '', nm_usuario_p,
			0, 0, 0);
	/* Log de progresso da geração dos dados do SIP*/

	/*insert into logxxxx_tasy
		(dt_atualizacao, nm_usuario, cd_log,
		ds_log)
	values (sysdate, nm_usuario_p, 2008,
		ie_tipo_plano_w || ' - ' || ie_tipo_beneficiario_w);*/
	commit;
	/* Controle da barra de progressão */

	CALL gravar_processo_longo('Cursor C01','SIP_GERAR_ITEM_DESPESA',-1);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_gerar_anexo_ii ( nr_seq_lote_sip_p bigint, nm_usuario_p text) FROM PUBLIC;
