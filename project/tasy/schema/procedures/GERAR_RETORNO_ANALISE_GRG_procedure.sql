-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_analise_grg ( nr_seq_lote_p bigint, nm_usuario_p text, cd_convenio_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_autorizacao_w		varchar(20);
nr_interno_conta_w		bigint;
vl_pago_w			double precision;
nr_seq_retorno_w		bigint;
nr_seq_ret_item_w		bigint;
nr_seq_guia_w			bigint;
nr_seq_ret_glosa_w		bigint;
qt_glosa_w			double precision;
cd_material_w			bigint;
cd_procedimento_w		bigint;
vl_amenor_guia_w		double precision;
vl_amenor_w			double precision;
nr_seq_propaci_w		bigint;
nr_seq_matpaci_w		bigint;
nr_titulo_w			bigint;
ie_origem_proced_w		bigint;
cd_motivo_glosa_w		lote_audit_hist_item.cd_motivo_glosa%type;
cd_setor_responsavel_w		lote_audit_hist_item.cd_setor_responsavel%type;
nr_seq_partic_w			lote_audit_hist_item.nr_seq_partic%type;
cd_setor_atendimento_w		setor_atendimento.cd_setor_atendimento%type;
cd_resposta_w			lote_audit_hist_item.cd_resposta%type;
vl_cobrado_w			convenio_retorno_glosa.vl_cobrado%type;
qt_cobrada_w			convenio_retorno_glosa.qt_cobrada%type;
vl_acatado_w			double precision;
vl_pago_guia_w			double precision;
vl_pago_guia_insert_w		double precision;
nr_seq_retorno_guia_w		convenio_retorno.nr_sequencia%type;
qt_importacao_w			integer := 0;
vl_saldo_reap_w         	convenio_retorno_glosa.vl_saldo_reap%type;
nr_seq_tiss_conta_proc_w	tiss_conta_proc.nr_sequencia%type;
nr_seq_tiss_conta_desp_w	tiss_conta_desp.nr_sequencia%type;
ie_acao_glosa_w			convenio_retorno_glosa.ie_acao_glosa%type;
qt_cobrada_grg_w			convenio_retorno_glosa.qt_cobrada%type;

C01 CURSOR FOR
SELECT	b.nr_Sequencia,
	b.cd_autorizacao,
	b.nr_interno_conta,
	obter_valores_guia_grc(b.nr_seq_lote_hist,b.nr_interno_conta,b.cd_autorizacao,'VA') vl_amenor_guia,
	obter_valores_guia_grc(b.nr_seq_lote_hist,b.nr_interno_conta,b.cd_autorizacao,'VP') vl_pago_guia,
	(obter_titulo_conta_guia(b.nr_interno_conta,b.cd_autorizacao,null,null))::numeric  nr_titulo,
	b.nr_seq_retorno
from	lote_audit_hist a,
	lote_audit_hist_guia b
where	b.nr_seq_lote_hist	= a.nr_sequencia
and	a.nr_Seq_lote_audit	= nr_Seq_lote_p
and	a.nr_Sequencia		= (	select 	max(x.nr_sequencia)
					from	lote_audit_hist x
					where	x.nr_Seq_lote_audit	= nr_seq_lote_p)
and	exists (select	1
		from	lote_audit_hist_item x
		where	x.nr_seq_guia	= b.nr_sequencia
		and	x.ie_Acao_glosa	<> 'A');

C02 CURSOR FOR
SELECT	a.nr_seq_propaci,
	a.nr_seq_matpaci,
	a.vl_amenor,
	a.qt_item,
	a.cd_motivo_glosa,
	a.cd_setor_responsavel,
	a.cd_resposta,
	a.nr_seq_partic,
    a.ie_acao_glosa,
    a.vl_pago,
	coalesce((	select	max(x.cd_setor_atendimento)
		from	procedimento_paciente x
		where	x.nr_sequencia		= a.nr_seq_propaci),
		(select	max(x.cd_setor_atendimento)
		from	material_atend_paciente x
		where	x.nr_sequencia		= a.nr_seq_matpaci)) cd_setor_atendimento,
	a.nr_seq_tiss_conta_proc,
	a.nr_seq_tiss_conta_desp
from	lote_audit_hist_item a
where	a.nr_seq_guia		= nr_seq_guia_w
and	a.ie_acao_glosa		<> 'A';


BEGIN

begin
	select 	sum((obter_valores_guia_grc(a.nr_seq_lote_hist,a.nr_interno_conta,a.cd_autorizacao,'VAC'))::numeric )
	into STRICT	vl_acatado_w
	from	lote_audit_hist_guia a
	where	a.nr_seq_lote_hist = (	SELECT 	max(x.nr_sequencia)
					from	lote_audit_hist x
					where	x.nr_Seq_lote_audit	= nr_seq_lote_p );
				
exception
when others then
	vl_acatado_w := 0;
end;	

if (coalesce(vl_acatado_w,0) > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1042260);
end if;	
					
select 	nextval('convenio_retorno_seq')
into STRICT	nr_seq_retorno_w
;

insert into convenio_retorno(cd_convenio,
	cd_estabelecimento,
	dt_atualizacao,
	dt_retorno,
	ie_status_retorno,
	nm_usuario,
	nm_usuario_retorno,
	nr_Sequencia,
	ds_observacao)
values (cd_convenio_p,
	cd_estabelecimento_p,
	clock_timestamp(),
	clock_timestamp(),
	'R',
	nm_usuario_p,
	nm_usuario_p,
	nr_seq_retorno_w,
	--'Retorno gerado pela analise de GRG do lote '||nr_seq_lote_p);
	wheb_mensagem_pck.get_texto(304124, 'NR_LOTE=' || nr_seq_lote_p));
	
open C01;
loop
fetch C01 into
	nr_seq_guia_w,
	cd_autorizacao_w,
	nr_interno_conta_w,
	vl_amenor_guia_w,
	vl_pago_guia_w,
	nr_titulo_w,
	nr_seq_retorno_guia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

    vl_pago_guia_insert_w := 0;

	select	nextval('convenio_retorno_item_seq')
	into STRICT	nr_seq_ret_item_w
	;
	
	if (vl_pago_guia_w > 0) and (coalesce(nr_seq_retorno_guia_w::text, '') = '')then
		
		select 	count(*)
		into STRICT	qt_importacao_w
		from	lote_audit_hist_imp
		where	nr_interno_conta = nr_interno_conta_w
		and	nr_doc_convenio = cd_autorizacao_w;
		
		if (qt_importacao_w > 0) then
			begin
			vl_pago_guia_insert_w := vl_pago_guia_w;
			end;
		end if;
		
	end if;

	insert into convenio_retorno_item(cd_autorizacao,
		dt_atualizacao,
		ie_analisada,
		ie_glosa,
		nm_usuario,
		nr_Seq_retorno,
		nr_sequencia,
		vl_adicional,
		vl_amenor,
		vl_glosado,
		vl_pago,
		nr_interno_conta,
		nr_titulo)
	values (cd_autorizacao_w,
		clock_timestamp(),
		'N',
		'P',
		nm_usuario_p,
		nr_seq_retorno_w,
		nr_seq_ret_item_w,
		0,
		vl_amenor_guia_w,
		0,
		coalesce(vl_pago_guia_insert_w,0),
		nr_interno_conta_w,
		nr_titulo_w);

	open C02;
	loop
	fetch C02 into
		nr_seq_propaci_w,
		nr_seq_matpaci_w,
		vl_amenor_w,
		qt_cobrada_grg_w,
		cd_motivo_glosa_w,
		cd_setor_responsavel_w,
		cd_resposta_w,
		nr_seq_partic_w,
        ie_acao_glosa_w,
        vl_pago_w,
		cd_setor_atendimento_w,
		nr_seq_tiss_conta_proc_w,
		nr_seq_tiss_conta_desp_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */

		cd_procedimento_w	:= null;
		ie_origem_proced_w	:= null;
		cd_material_w		:= null;

		select 	nextval('convenio_retorno_glosa_seq')
		into STRICT	nr_seq_ret_glosa_w
		;

		if (nr_seq_propaci_w IS NOT NULL AND nr_seq_propaci_w::text <> '') then
			
			begin			
			if (nr_seq_partic_w IS NOT NULL AND nr_seq_partic_w::text <> '') then
				select	p.cd_procedimento,
					p.ie_origem_proced,
					pa.vl_participante,
					p.qt_procedimento,
                    coalesce((obter_valor_amenor_ult_ret(null,null,null,p.nr_interno_conta,p.nr_sequencia,null,1))::numeric ,p.vl_procedimento - coalesce(obter_glosa_item_procmat(p.nr_sequencia, null, 2, null),0))
				into STRICT	cd_procedimento_w,
					ie_origem_proced_w,
					vl_cobrado_w,
					qt_cobrada_w,
                    vl_saldo_reap_w
				from	procedimento_paciente p, procedimento_participante pa
				where	pa.nr_sequencia = p.nr_sequencia
				and	p.nr_interno_conta	= nr_interno_conta_w				
				and	p.nr_sequencia		= nr_seq_propaci_w
				and	pa.nr_seq_partic	= nr_seq_partic_w  LIMIT 1;			
			else
				select	cd_procedimento,
					ie_origem_proced,
					case when coalesce(obter_participantes_proc(nr_sequencia),'X') = 'X' then
						vl_procedimento else vl_medico end as vl_proc,
					qt_procedimento,
                    coalesce((obter_valor_amenor_ult_ret(null,null,null,nr_interno_conta,nr_sequencia,null,1))::numeric ,vl_procedimento - coalesce(obter_glosa_item_procmat(nr_sequencia, null, 2, null),0))
				into STRICT	cd_procedimento_w,
					ie_origem_proced_w,
					vl_cobrado_w,
					qt_cobrada_w,
                    vl_saldo_reap_w
				from	procedimento_paciente
				where	nr_interno_conta	= nr_interno_conta_w
				and	nr_sequencia		= nr_seq_propaci_w  LIMIT 1;			
			end if;
			exception
			when others then
				cd_procedimento_w := null;
				ie_origem_proced_w := null;
				vl_cobrado_w := null;
				qt_cobrada_w := null;
			end;			
		elsif (nr_seq_matpaci_w IS NOT NULL AND nr_seq_matpaci_w::text <> '') then
			begin
			select	cd_material,
                (CASE coalesce(qt_cobrada_grg_w,0)
                WHEN 0 THEN 1
                ELSE coalesce(qt_cobrada_grg_w, 1)
                END) * vl_unitario,
				qt_material,
                 coalesce((obter_valor_amenor_ult_ret(NULL,NULL,NULL,nr_interno_conta,NULL,nr_sequencia,1))::numeric , vl_material - coalesce(obter_glosa_item_procmat(nr_sequencia, NULL, 2),0))
			into STRICT	cd_material_w,
				vl_cobrado_w,
				qt_cobrada_w,
                vl_saldo_reap_w
			from	material_atend_paciente
			where	nr_interno_conta	= nr_interno_conta_w
			and	nr_sequencia		= nr_seq_matpaci_w  LIMIT 1;			
			exception
			when others then
				cd_material_w := null;
				vl_cobrado_w := null;
				qt_cobrada_w := null;
			end;
		end if;

		insert into convenio_retorno_glosa(dt_atualizacao,
			ie_atualizacao,
			nm_usuario,
			nr_Seq_ret_item,
			nr_sequencia,
			vl_glosa,
			nr_seq_propaci,
			nr_seq_matpaci,
			cd_procedimento,
			cd_material,
			cd_motivo_glosa,
			cd_resposta,
			cd_setor_responsavel,
			cd_setor_atendimento,
			vl_cobrado,
			qt_cobrada,
			vl_pago_digitado,
			nr_seq_partic,
			vl_saldo_reap,
			nr_seq_tiss_conta_proc,
			nr_seq_tiss_conta_desp,
            vl_informado,
            ie_acao_glosa,
            vl_liberado,
            qt_glosa,
	    ie_origem_proced)
		values (clock_timestamp(),
			'N',
			nm_usuario_p,
			nr_seq_ret_item_w,
			nr_seq_ret_glosa_w,
			vl_amenor_w,
			nr_seq_propaci_w,
			nr_seq_matpaci_w,
			cd_procedimento_w,
			cd_material_w,
			cd_motivo_glosa_w,
			cd_resposta_w,
			cd_setor_responsavel_w,
			cd_setor_atendimento_w,
			vl_cobrado_w,
			qt_cobrada_grg_w,
			0,
			nr_seq_partic_w,
			vl_saldo_reap_w,
			nr_seq_tiss_conta_proc_w,
			nr_seq_tiss_conta_desp_w,
            vl_cobrado_w,
            ie_acao_glosa_w,
            vl_pago_w,
            0,
	    ie_origem_proced_w);

	end loop;
	close C02;
	
	update  lote_audit_hist_guia
	set    	nr_seq_retorno  = coalesce(nr_seq_retorno,nr_seq_retorno_w)
	where  	nr_sequencia  = nr_seq_guia_w;

end loop;
close C01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_analise_grg ( nr_seq_lote_p bigint, nm_usuario_p text, cd_convenio_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
