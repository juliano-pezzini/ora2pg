-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_pos_estab_ptu ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_analise_p bigint, ie_comitar_p text, cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE

 
/*Esta procedure tem por finalidade obter os valores de pós e atualizar a análise da mesma ou criar a mesma se necessário.*/
 
 
 
ie_origem_analise_w		varchar(1);
nr_seq_analise_pos_w		bigint;

nr_seq_item_w			bigint;
ie_tipo_item_w			varchar(1);
cd_item_w			bigint;
ie_origem_proced_w		bigint;
ie_tipo_despesa_w		varchar(10);
ie_via_acesso_w			varchar(10);
dt_item_w			timestamp;
tx_item_w			double precision;
ie_tipo_guia_w			varchar(10);
cd_guia_referencia_w		varchar(20);
cd_guia_w			varchar(20);
ds_item_w			varchar(255);
ds_via_acesso_w			varchar(255);
ds_tipo_guia_w			varchar(255);
vl_calculado_w			double precision;
nr_seq_protocolo_w		bigint;
ie_status_conta_w		varchar(1);
ds_status_conta_w		varchar(120);
nr_seq_guia_w			bigint;
ie_autorizado_w			varchar(1)	:= 'N';
nr_seq_segurado_w		bigint;
cd_usuario_plano_w		varchar(30);
nm_segurado_w			varchar(255);
nr_identificador_w		bigint;
nr_seq_item_analise_w		bigint;
nr_seq_conta_pos_estab_w	bigint;
vl_beneficiario_w		double precision;
nr_seq_item_princ_w		bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_analise_ref_w		bigint;
ie_status_w			varchar(1);
ie_pagamento_w			varchar(1);
nr_seq_regra_preco_pos_w	bigint;
nr_seq_partic_w			bigint;
cd_medico_w			varchar(10);
nr_seq_cbo_saude_ww		bigint;
nr_seq_conselho_w		bigint;
nr_seq_grau_partic_ww		bigint;
nr_seq_honorario_crit_w		bigint;
nr_seq_prestador_w		bigint;
nr_seq_prestador_pgto_w		bigint;
vl_honorario_medico_w		double precision;
vl_participante_w		double precision;
nm_participante_ww		varchar(255);
ds_grau_participacao_ww		varchar(255);
vl_apresentado_w		double precision;
vl_unitario_apres_w		double precision;
nr_seq_apres_ww			bigint;
nr_seq_item_ref_w		bigint;
nr_seq_w_resumo_conta_w		bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_analise_pagto_w		bigint;
nr_seq_w_resumo_conta_ww	bigint;
nr_seq_conta_proc_ww		bigint;
nr_seq_conta_mat_ww		bigint;
nr_seq_partic_proc_ww		bigint;
nr_seq_pos_estab_interc_w	bigint;
nr_seq_res_conta_princ_w	bigint;
nr_ordem_w			bigint;
cd_item_convertido_w		varchar(30);
ds_item_convertido_w		varchar(255);

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		'P', 
		a.cd_procedimento, 
		a.ie_origem_proced, 
		a.ie_tipo_despesa, 
		a.ie_via_acesso, 
		a.dt_procedimento, 
		a.tx_item, 
		b.nr_sequencia, 
		b.vl_beneficiario, 
		a.nr_sequencia, 
		null, 
		ie_status, 
		b.nr_seq_regra_pos_estab, 
		coalesce(a.nr_seq_proc_ref,a.nr_sequencia), 
		nr_seq_pos_estab_interc, 
		b.cd_item_convertido, 
		b.ds_item_convertido 
	from	pls_conta_proc			a, 
		pls_conta_pos_estabelecido	b 
	where	a.nr_sequencia = b.nr_seq_conta_proc 
	and	(((a.nr_seq_conta	= nr_seq_conta_p) and ((coalesce(nr_seq_conta_proc_p,0) = 0) and (coalesce(nr_seq_conta_mat_p,0) = 0))) 
	or (a.nr_sequencia = nr_seq_conta_proc_p)) 
	and	((b.ie_situacao		= 'A') or (coalesce(b.ie_situacao::text, '') = '')) 
	
union
 
	SELECT	a.nr_sequencia, 
		'M', 
		a.nr_seq_material, 
		null, 
		a.ie_tipo_despesa, 
		'', 
		a.dt_atendimento, 
		a.tx_reducao_acrescimo, 
		b.nr_sequencia, 
		b.vl_beneficiario, 
		null, 
		a.nr_sequencia, 
		ie_status, 
		b.nr_seq_regra_pos_estab, 
		null, 
		nr_seq_pos_estab_interc, 
		b.cd_item_convertido, 
		b.ds_item_convertido 
	from	pls_conta_mat			a, 
		pls_conta_pos_estabelecido 	b 
	where	a.nr_sequencia = b.nr_seq_conta_mat 
	and	(((a.nr_seq_conta	= nr_seq_conta_p) and ((coalesce(nr_seq_conta_proc_p,0) = 0) and (coalesce(nr_seq_conta_mat_p,0) = 0))) 
	or (a.nr_sequencia = nr_seq_conta_mat_p)) 
	and	((b.ie_situacao		= 'A') or (coalesce(b.ie_situacao::text, '') = ''));

C02 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.cd_medico, 
		a.nr_seq_cbo_saude, 
		a.nr_seq_conselho, 
		a.nr_seq_grau_partic, 
		a.nr_seq_honorario_crit, 
		a.nr_seq_prestador, 
		a.nr_seq_prestador_pgto, 
		'R', 
		CASE WHEN coalesce(a.nr_seq_prestador::text, '') = '' THEN coalesce(Obter_nome_medico(a.cd_medico,'N'), a.nm_medico_executor_imp)  ELSE pls_obter_dados_prestador(a.nr_Seq_prestador,'N') END , 
		pls_obter_grau_participacao(a.nr_seq_grau_partic), 
		b.nr_seq_apres, 
		a.vl_participante 
	FROM pls_conta d, pls_conta_proc c, pls_proc_participante a
LEFT OUTER JOIN pls_grau_participacao b ON (a.nr_seq_grau_partic = b.nr_sequencia)
WHERE a.nr_seq_conta_proc	= c.nr_sequencia and c.nr_seq_conta		= d.nr_sequencia and c.nr_sequencia 		= nr_seq_item_w and d.ie_tipo_guia		in ('5','4') order by nr_seq_apres;

C03 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_conta_proc, 
		nr_seq_conta_mat, 
		nr_seq_partic_proc 
	from	w_pls_resumo_conta 
	where	coalesce(nr_seq_item_princ,0) = 0 
	and	coalesce(nr_seq_res_conta_princ,0) = 0 
	and	nr_seq_analise = nr_seq_analise_pos_w;


BEGIN 
 
select	max(ie_origem_analise) 
into STRICT	ie_origem_analise_w 
from	pls_analise_conta 
where	nr_sequencia = nr_seq_analise_p;
 
if (ie_origem_analise_w = '2') then 
	/*Se for uma análse de pós.*/
 
	nr_seq_analise_pos_w := nr_seq_analise_p;
 
	select	max(nr_seq_analise_ref) 
	into STRICT	nr_seq_analise_pagto_w 
	from	pls_analise_conta 
	where	nr_sequencia = nr_seq_analise_p;
else 
	/*Se for uma análise de pagto.*/
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_analise_pos_w 
	from	pls_analise_conta 
	where	nr_seq_analise_ref = nr_seq_analise_p;
 
	nr_seq_analise_pagto_w := nr_seq_analise_p;
end if;
 
select	max(ie_origem_analise) 
into STRICT	ie_origem_analise_w 
from	pls_analise_conta 
where	nr_sequencia = nr_seq_analise_pagto_w;
 
/* Obter dados conta */
 
select	ie_tipo_guia, 
	cd_guia_referencia, 
	cd_guia, 
	nr_seq_protocolo, 
	ie_status, 
	obter_valor_dominio(1746,ie_tipo_guia), 
	obter_valor_dominio(1961,ie_status), 
	nr_seq_segurado, 
	pls_obter_dados_segurado(nr_seq_segurado,'C'), 
	pls_obter_dados_segurado(nr_seq_segurado,'N'), 
	nr_seq_guia 
into STRICT	ie_tipo_guia_w, 
	cd_guia_referencia_w, 
	cd_guia_w, 
	nr_seq_protocolo_w, 
	ie_status_conta_w, 
	ds_tipo_guia_w, 
	ds_status_conta_w, 
	nr_seq_segurado_w, 
	cd_usuario_plano_w, 
	nm_segurado_w, 
	nr_seq_guia_w 
from	pls_conta 
where	nr_sequencia	= nr_seq_conta_p;
 
open C01;
loop 
fetch C01 into 
	nr_seq_item_w, 
	ie_tipo_item_w, 
	cd_item_w, 
	ie_origem_proced_w, 
	ie_tipo_despesa_w, 
	ie_via_acesso_w, 
	dt_item_w, 
	tx_item_w, 
	nr_seq_conta_pos_estab_w, 
	vl_beneficiario_w, 
	nr_seq_conta_proc_w, 
	nr_seq_conta_mat_w, 
	ie_status_w, 
	nr_seq_regra_preco_pos_w, 
	nr_seq_item_ref_w, 
	nr_seq_pos_estab_interc_w, 
	cd_item_convertido_w, 
	ds_item_convertido_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select	CASE WHEN coalesce(ie_origem_proced_w::text, '') = '' THEN pls_obter_desc_material(cd_item_w)  ELSE obter_descricao_procedimento(cd_item_w,ie_origem_proced_w) END , 
		obter_valor_dominio(1268,ie_via_acesso_w) 
	into STRICT	ds_item_w, 
		ds_via_acesso_w 
	;
 
	if (coalesce(nr_seq_guia_w,0) > 0) then 
		select	CASE WHEN ie_status=1 THEN  'S'  ELSE 'N' END  
		into STRICT	ie_autorizado_w 
		from	pls_guia_plano 
		where	nr_sequencia = nr_seq_guia_w;
	end if;
 
	select (coalesce(max(nr_identificador),0) + 1) 
	into STRICT	nr_identificador_w 
	from	w_pls_resumo_conta 
	where	nr_seq_analise = nr_seq_analise_pos_w;
 
	select	max(a.nr_sequencia) 
	into STRICT	nr_seq_item_princ_w 
	from	w_pls_resumo_conta	a, 
		pls_analise_conta	b 
	where	a.nr_seq_analise	= b.nr_sequencia 
	and	((a.nr_seq_conta_proc	= nr_seq_conta_proc_w) 
	or (a.nr_seq_conta_mat	= nr_seq_conta_mat_w)) 
	and	b.nr_sequencia		= nr_seq_analise_pagto_w;
 
	if (ie_status_w = 'M' ) then 
		ie_status_w 	:= 'L';
		ie_pagamento_w 	:= 'L';
	else 
		ie_status_w 	:= 'U';
		ie_pagamento_w 	:= 'G';
	end if;
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_w_resumo_conta_w 
	from	w_pls_resumo_conta 
	where	((nr_seq_conta_proc 	= nr_seq_conta_proc_w) 
	or (nr_seq_conta_mat	= nr_seq_conta_mat_w)) 
	and	nr_seq_analise		= nr_seq_analise_pos_w;
 
	if (coalesce(nr_seq_item_princ_w::text, '') = '') then 
		select	max(nr_seq_res_conta_princ) 
		into STRICT	nr_seq_res_conta_princ_w 
		from	w_pls_resumo_conta 
		where	nr_sequencia = nr_seq_w_resumo_conta_w;
	end if;
 
	if (ie_tipo_item_w = 'P') then 
		select	max(a.nr_sequencia) 
		into STRICT	nr_seq_partic_w 
		from	pls_proc_participante	a, 
			pls_conta_proc		c 
		where	a.nr_seq_conta_proc	= c.nr_sequencia 
		and	c.nr_sequencia 		= nr_seq_item_w;
 
		if (coalesce(nr_seq_partic_w,0) > 0) then 
			select	a.cd_medico, 
				a.nr_seq_cbo_saude, 
				a.nr_seq_conselho, 
				a.nr_seq_grau_partic, 
				a.nr_seq_honorario_crit, 
				a.nr_seq_prestador, 
				a.nr_seq_prestador_pgto, 
				'R', 
				CASE WHEN coalesce(a.nr_seq_prestador::text, '') = '' THEN coalesce(Obter_nome_medico(a.cd_medico,'N'), a.nm_medico_executor_imp)  ELSE pls_obter_dados_prestador(a.nr_Seq_prestador,'N') END , 
				pls_obter_grau_participacao(a.nr_seq_grau_partic), 
				b.nr_seq_apres 
			into STRICT	cd_medico_w, 
				nr_seq_cbo_saude_ww, 
				nr_seq_conselho_w, 
				nr_seq_grau_partic_ww, 
				nr_seq_honorario_crit_w, 
				nr_seq_prestador_w, 
				nr_seq_prestador_pgto_w, 
				ie_tipo_item_w, 
				nm_participante_ww, 
				ds_grau_participacao_ww, 
				nr_seq_apres_ww 
			FROM pls_conta d, pls_conta_proc c, pls_proc_participante a
LEFT OUTER JOIN pls_grau_participacao b ON (a.nr_seq_grau_partic = b.nr_sequencia)
WHERE a.nr_seq_conta_proc	= c.nr_sequencia and c.nr_seq_conta		= d.nr_sequencia and a.nr_sequencia 		= nr_seq_partic_w;
		end if;
	end if;
 
	select	CASE WHEN ie_tipo_item_w || ie_tipo_despesa_w='P1' THEN '1' WHEN ie_tipo_item_w || ie_tipo_despesa_w='P2' THEN '3' WHEN ie_tipo_item_w || ie_tipo_despesa_w='P3' THEN '2' WHEN ie_tipo_item_w || ie_tipo_despesa_w='P4' THEN '4' WHEN ie_tipo_item_w || ie_tipo_despesa_w='M1' THEN '6' WHEN ie_tipo_item_w || ie_tipo_despesa_w='M2' THEN '5' WHEN ie_tipo_item_w || ie_tipo_despesa_w='M3' THEN '7' WHEN ie_tipo_item_w || ie_tipo_despesa_w='M7' THEN '8' WHEN ie_tipo_item_w || ie_tipo_despesa_w='R1' THEN '1' WHEN ie_tipo_item_w || ie_tipo_despesa_w='R2' THEN '3' WHEN ie_tipo_item_w || ie_tipo_despesa_w='R3' THEN '2' WHEN ie_tipo_item_w || ie_tipo_despesa_w='R4' THEN '4' END  
	into STRICT	nr_ordem_w 
	;
	 
	if (coalesce(nr_seq_w_resumo_conta_w,0) = 0) then 
		select	nextval('w_pls_resumo_conta_seq') 
		into STRICT	nr_seq_item_analise_w 
		;
 
		insert into w_pls_resumo_conta(nr_sequencia, nr_seq_conta, nr_seq_item, 
			ds_tipo_despesa, ie_via_acesso, dt_item, 
			cd_item, ie_origem_proced, tx_item, 
			ie_tipo_guia, cd_guia_referencia, cd_guia, 
			nm_usuario, dt_atualizacao, nm_usuario_nrec, 
			dt_atualizacao_nrec, ds_item, ds_via_acesso, 
			ds_tipo_guia, ie_status, vl_calculado, 
			nr_seq_protocolo, ie_status_conta, ie_tipo_despesa, 
			ie_tipo_item, ds_status_conta, nr_seq_analise, 
			nr_seq_guia, ie_pagamento, nr_seq_segurado, 
			nm_segurado, cd_usuario_plano, nr_identificador, 
			vl_total, vl_total_apres, nr_seq_item_princ, 
			nr_seq_conta_proc, nr_seq_conta_mat, nr_seq_regra_preco_pos, 
			nr_seq_item_ref, nr_seq_pos_estab_interc, nr_seq_res_conta_princ, 
			nr_seq_apres_prof, nm_participante, nr_seq_grau_partic, 
			nr_seq_cbo_saude, ds_grau_participacao, nr_ordem, 
			cd_item_convertido, ds_item_convertido) 
		values (nr_seq_item_analise_w, nr_seq_conta_p, nr_seq_item_w, 
			ie_tipo_item_w || ie_tipo_despesa_w, ie_via_acesso_w, dt_item_w, 
			cd_item_w, ie_origem_proced_w, tx_item_w, 
			ie_tipo_guia_w, cd_guia_referencia_w, cd_guia_w, 
			nm_usuario_p, clock_timestamp(), nm_usuario_p, 
			clock_timestamp(), ds_item_w, ds_via_acesso_w, 
			ds_tipo_guia_w, ie_status_w, coalesce(vl_beneficiario_w,0), 
			nr_seq_protocolo_w, ie_status_conta_w, ie_tipo_despesa_w, 
			ie_tipo_item_w, ds_status_conta_w, nr_seq_analise_pos_w, 
			nr_seq_guia_w, ie_pagamento_w , nr_seq_segurado_w, 
			nm_segurado_w, cd_usuario_plano_w, nr_identificador_w, 
			0, coalesce(vl_beneficiario_w,0), nr_seq_item_princ_w, 
			nr_seq_conta_proc_w, nr_seq_conta_mat_w, nr_seq_regra_preco_pos_w, 
			nr_seq_item_ref_w, nr_seq_pos_estab_interc_w, nr_seq_res_conta_princ_w, 
			nr_seq_apres_ww, nm_participante_ww, nr_seq_grau_partic_ww, 
			nr_seq_cbo_saude_ww, ds_grau_participacao_ww, nr_ordem_w, 
			cd_item_convertido_w, ds_item_convertido_w);
	else 
		update	w_pls_resumo_conta 
		set	nr_seq_conta		= nr_seq_conta_p, 
			nr_seq_item		= nr_seq_item_w, 
			ds_tipo_despesa		= ie_tipo_item_w || ie_tipo_despesa_w, 
			ie_via_acesso		= ie_via_acesso_w, 
			dt_item			= dt_item_w, 
			cd_item			= cd_item_w, 
			ie_origem_proced	= ie_origem_proced_w, 
			tx_item 		= tx_item_w, 
			ie_tipo_guia		= ie_tipo_guia_w, 
			cd_guia_referencia	= cd_guia_referencia_w, 
			cd_guia			= cd_guia_w, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp(), 
			ds_item			= ds_item_w, 
			ds_via_acesso		= ds_via_acesso_w, 
			ds_tipo_guia		= ds_tipo_guia_w, 
			vl_calculado		= coalesce(vl_beneficiario_w,0), 
			nr_seq_protocolo	= nr_seq_protocolo_w, 
			ie_status_conta		= ie_status_conta_w, 
			ie_tipo_despesa		= ie_tipo_despesa_w, 
			ie_tipo_item		= ie_tipo_item_w, 
			ds_status_conta		= ds_status_conta_w, 
			nr_seq_analise		= nr_seq_analise_pos_w, 
			nr_seq_guia		= nr_seq_guia_w, 
			nr_seq_segurado		= nr_seq_segurado_w, 
			nm_segurado		= nm_segurado_w, 
			cd_usuario_plano	= cd_usuario_plano_w, 
			--nr_identificador		= nr_identificador_w, Retirado do update pois não se pode mudar o identificador depois que ele foi gerado. 
			vl_total		= 0, 
			vl_total_apres		= coalesce(vl_beneficiario_w,0), 
			nr_seq_item_princ	= nr_seq_item_princ_w, 
			nr_seq_conta_proc	= nr_seq_conta_proc_w, 
			nr_seq_conta_mat	= nr_seq_conta_mat_w, 
			nr_seq_regra_preco_pos	= nr_seq_regra_preco_pos_w, 
			nr_seq_item_ref		= nr_seq_item_ref_w, 
			nr_seq_pos_estab_interc = nr_seq_pos_estab_interc_w, 
			nr_seq_res_conta_princ	= nr_seq_item_analise_w, 
			nr_seq_apres_prof	= nr_seq_apres_ww, 
			nm_participante		= nm_participante_ww, 
			nr_seq_grau_partic	= nr_seq_grau_partic_ww, 
			nr_seq_cbo_saude	= nr_seq_cbo_saude_ww, 
			ds_grau_participacao	= ds_grau_participacao_ww, 
			nr_ordem		= nr_ordem_w, 
			cd_item_convertido	= CASE WHEN cd_item_convertido = NULL THEN cd_item_convertido_w  ELSE cd_item_convertido END , 
			ds_item_convertido	= CASE WHEN cd_item_convertido = NULL THEN cd_item_convertido_w  ELSE cd_item_convertido END  
		where	nr_sequencia		= nr_seq_w_resumo_conta_w;
	end if;
	end;
end loop;
close C01;
 
open C03;
loop 
fetch C03 into 
	nr_seq_w_resumo_conta_ww, 
	nr_seq_conta_proc_ww, 
	nr_seq_conta_mat_ww, 
	nr_seq_partic_proc_ww;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin 
 
	delete 	FROM pls_analise_conta_item 
	where	((nr_seq_conta_proc = nr_seq_conta_proc_ww) 
	or (nr_seq_conta_mat  = nr_seq_conta_mat_ww)) 
	and	nr_seq_analise 	   = nr_seq_analise_pos_w;
 
	select 	max(nr_sequencia) 
	into STRICT 	nr_seq_ocorrencia_w 
	from 	pls_ocorrencia_benef 
	where 	((nr_seq_proc 		= nr_seq_conta_proc_ww) 
	or (nr_seq_mat  		= nr_seq_conta_mat_ww)) 
	and 	nr_seq_conta_pos_estab	= nr_seq_conta_pos_estab_w;
 
	delete	FROM pls_ocorrencia_benef 
	where	((nr_seq_proc = nr_seq_conta_proc_ww) 
	or (nr_seq_mat  = nr_seq_conta_mat_ww));
 
 
	delete	FROM w_pls_resumo_conta 
	where	nr_sequencia = nr_seq_w_resumo_conta_ww;
 
	end;
end loop;
close C03;
 
if (coalesce(ie_comitar_p,'N') = 'N') then 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_pos_estab_ptu ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_analise_p bigint, ie_comitar_p text, cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;

