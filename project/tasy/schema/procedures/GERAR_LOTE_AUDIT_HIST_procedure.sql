-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lote_audit_hist (nr_seq_lote_hist_p bigint, nm_usuario_p text, nr_seq_retorno_p bigint, ie_gerar_itens_p text, ie_guia_sem_saldo_p text, ie_gerar_lotes_p text default 'N', ds_retorno_p INOUT text DEFAULT NULL) AS $body$
DECLARE


nr_seq_retorno_w		bigint;
nr_seq_ret_item_w		bigint;
nr_seq_lote_guia_w		bigint;
cd_autorizacao_w		varchar(20);
nr_interno_conta_w		bigint;
nr_seq_lote_w			bigint;
nr_seq_lote_ant_w		bigint;
nr_analise_w			bigint;
nr_seq_lote_hist_w		bigint;
nr_seq_guia_ant_w		bigint;
ie_guia_sem_saldo_w		varchar(1);
vl_amenor_w			double precision;
vl_guia_w			double precision;
ds_observacao_w			varchar(4000);
ie_somente_motivo_w		varchar(1);
cd_estabelecimento_w		smallint;
ie_glosa_aceita_grg_w		varchar(1);
cd_convenio_w			integer;
ie_guias_com_itens_w		varchar(1);
qt_itens_guia_w			bigint;
ie_gerar_acao_w			varchar(1);
ie_gerar_resposta_w		varchar(1);
ie_gerar_justificativa_w	varchar(1);
nr_titulo_w			bigint;
vl_saldo_titulo_w		double precision;
ie_conta_outro_lote_w		varchar(10) 	:= 'S';
ds_retorno_w			varchar(4000) 	:= null;
ie_insere_conta_w		varchar(10);
ie_permite_gerar_analise_w	varchar(1) := 'N';
--vl_amenor_w			number(15,2);
vl_glosado_w			double precision;
nr_seq_item_w			bigint;
dt_pagamento_w			convenio_retorno_item.dt_pagamento%type;
ie_trib_titulo_retorno_w	convenio_estabelecimento.ie_trib_titulo_retorno%type;

vl_tributo_guia_w		convenio_retorno_item.vl_tributo_guia%type;
vl_saldo_guia_w			double precision;

c01 CURSOR FOR
SELECT	a.cd_autorizacao,
	a.nr_interno_conta,
	a.nr_sequencia,
	coalesce((obter_saldo_conpaci(a.nr_interno_conta,a.cd_autorizacao))::numeric ,0),
	a.ds_observacao,
	a.nr_titulo,
	a.dt_pagamento
from	convenio_retorno_item a
where	a.nr_seq_retorno	= nr_seq_retorno_p
and	((coalesce(ie_gerar_lotes_p,'N') = 'N'
	 and  not exists ( 	SELECT 1
			from	lote_audit_hist_guia x
			where	x.nr_seq_lote_hist	= nr_seq_lote_hist_p
			and	x.nr_interno_conta	= a.nr_interno_conta
			and	x.cd_autorizacao		= a.cd_autorizacao))
	or (coalesce(ie_gerar_lotes_p,'N') = 'S'
		and exists ( 	select 1
			from	lote_audit_hist_guia x
			where	x.nr_seq_lote_hist	= nr_seq_lote_hist_w
			and	x.nr_interno_conta	= a.nr_interno_conta
			and	x.cd_autorizacao		= a.cd_autorizacao)));

/* guias da analise anterior */

c03 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_autorizacao,
	a.nr_interno_conta,
	a.nr_seq_retorno,
	a.ie_guia_sem_saldo,
	coalesce((obter_saldo_conpaci(a.nr_interno_conta,a.cd_autorizacao))::numeric ,0),
	a.dt_pagamento
from	lote_audit_hist_guia a
where	a.nr_seq_lote_hist		= nr_seq_lote_hist_w
and	not exists (SELECT	1
	from	lote_audit_hist_guia x
	where	x.nr_seq_lote_hist	= nr_seq_lote_hist_p
	and	x.nr_interno_conta	= a.nr_interno_conta
	and	x.cd_autorizacao	= a.cd_autorizacao)
and	exists (select	1
	from	lote_audit_hist_item x
	where	x.nr_seq_guia		= a.nr_sequencia
	and	x.vl_amenor		> 0);


BEGIN

select	max(a.nr_sequencia),
	max(b.nr_analise),
	max(a.cd_estabelecimento),
	max(a.cd_convenio)
into STRICT	nr_seq_lote_w,
	nr_analise_w,
	cd_estabelecimento_w,
	cd_convenio_w
from	lote_auditoria a,
	lote_audit_hist b
where	b.nr_sequencia		= nr_seq_lote_hist_p
and	b.nr_seq_lote_audit	= a.nr_sequencia;

select	max(a.ie_glosa_aceita_grg),
	coalesce(max(a.ie_trib_titulo_retorno), 'N')
into STRICT	ie_glosa_aceita_grg_w,
	ie_trib_titulo_retorno_w
from	convenio_estabelecimento a
where	a.cd_estabelecimento	= cd_estabelecimento_w
and	a.cd_convenio		= cd_convenio_w;

if (nr_seq_retorno_p IS NOT NULL AND nr_seq_retorno_p::text <> '') then		/* usado na opcao "Gerar lote de recurso GRG", da Retorno Convenio */
	ie_guias_com_itens_w := obter_param_usuario(27, 164, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_guias_com_itens_w);
	ie_somente_motivo_w := obter_param_usuario(27, 132, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_somente_motivo_w);
	ie_conta_outro_lote_w := obter_param_usuario(27, 237, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_conta_outro_lote_w);
	ie_permite_gerar_analise_w := obter_param_usuario(27, 271, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_gerar_analise_w);
	
	qt_itens_guia_w	:= 1;
	
	select	max(a.nr_sequencia)		/* obter a analise anterior */
	into STRICT	nr_seq_lote_hist_w
	from	lote_audit_hist a
	where	a.nr_sequencia		<> nr_seq_lote_hist_p
	and	a.nr_seq_lote_audit	= nr_seq_lote_w;
	
	open c01;
	loop
	fetch c01 into
		cd_autorizacao_w,
		nr_interno_conta_w,
		nr_seq_ret_item_w,
		vl_guia_w,
		ds_observacao_w,
		nr_titulo_w,
		dt_pagamento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	
		if (coalesce(nr_titulo_w::text, '') = '') then
			select	max((obter_titulo_conta_guia(nr_interno_conta_w,cd_autorizacao_w,null,null))::numeric )
			into STRICT	nr_titulo_w
			;
		end if;
		
		select	max(b.nr_seq_lote_audit)
		into STRICT	nr_seq_lote_ant_w
		from	lote_audit_hist b,
			lote_audit_hist_guia a
		where	a.nr_interno_conta	= nr_interno_conta_w
		and	a.nr_seq_lote_hist	= b.nr_sequencia
		and	b.nr_seq_lote_audit	<> coalesce(nr_seq_lote_w,0);
		
		ie_insere_conta_w	:= 'S';
		
		/*lhalves em 05/10/2012 OS 449572*/

		if (coalesce(ie_conta_outro_lote_w,'S') = 'N') and (coalesce(nr_seq_lote_ant_w,0) > 0) then
			ds_retorno_w		:= substr(ds_retorno_w || substr(wheb_mensagem_pck.get_texto(307181),1,255) || nr_interno_conta_w ||
							substr(wheb_mensagem_pck.get_texto(307183),1,255) || nr_seq_lote_ant_w || chr(10),1,255);
			ie_insere_conta_w	:= 'N';
			/*wheb_mensagem_pck.exibir_mensagem_abort(210318,	'NR_INTERNO_CONTA_W='||nr_interno_conta_w||
									';NR_LOTE_W='||nr_seq_lote_ant_w);*/
		end if;
		
		select	coalesce(max(a.vl_saldo_titulo),0)
		into STRICT	vl_saldo_titulo_w
		from	titulo_receber a
		where	a.nr_titulo	= nr_titulo_w;
		
		vl_saldo_guia_w := (obter_saldo_conpaci(nr_interno_conta_w, cd_autorizacao_w))::numeric;
					
		/*
			nfcunha - SO 2203125 - 22/Jun/2021
			Descontar o tributo do saldo da guia.
		*/
		if ie_trib_titulo_retorno_w <> 'N' then
			select	sum(coalesce(vl_tributo_guia, 0))
			into STRICT	vl_tributo_guia_w
			from	convenio_retorno_item
			where	nr_interno_conta 	= nr_interno_conta_w
			and	cd_autorizacao 		= cd_autorizacao_w;

			vl_saldo_guia_w := vl_saldo_guia_w - vl_tributo_guia_w;
		end if;

		if (coalesce(ie_insere_conta_w,'S') = 'S') then
		
			if (coalesce(ie_guia_sem_saldo_p,'S') = 'S')
				or ((obter_saldo_conpaci(nr_interno_conta_w,cd_autorizacao_w))::numeric  <> 0 
				and (vl_saldo_titulo_w <> 0 and vl_saldo_titulo_w >= vl_saldo_guia_w)) then

				if (coalesce(ie_guias_com_itens_w,'N')	= 'S') then

					select	count(*)
					into STRICT	qt_itens_guia_w
					FROM procedimento_paciente d, convenio_retorno_glosa a
LEFT OUTER JOIN conta_paciente_ret_hist b ON (a.nr_seq_conpaci_ret_hist = b.nr_sequencia)
LEFT OUTER JOIN motivo_glosa c ON (a.cd_motivo_glosa = c.cd_motivo_glosa)
WHERE (coalesce(ie_glosa_aceita_grg_w,'S') = 'S' or ((a.cd_motivo_glosa IS NOT NULL AND a.cd_motivo_glosa::text <> '') and coalesce(a.ie_acao_glosa,c.ie_acao_glosa) <> 'A')) and a.nr_seq_ret_item		= nr_seq_ret_item_w   and a.nr_seq_propaci		= d.nr_sequencia and (coalesce(ie_somente_motivo_w,'N') = 'N' or (a.cd_motivo_glosa IS NOT NULL AND a.cd_motivo_glosa::text <> ''));

					if (coalesce(qt_itens_guia_w,0)	= 0) then
					
						select	count(*)
						into STRICT	qt_itens_guia_w
						FROM material_atend_paciente d, convenio_retorno_glosa a
LEFT OUTER JOIN conta_paciente_ret_hist b ON (a.nr_seq_conpaci_ret_hist = b.nr_sequencia)
LEFT OUTER JOIN motivo_glosa c ON (a.cd_motivo_glosa = c.cd_motivo_glosa)
WHERE (coalesce(ie_glosa_aceita_grg_w,'S') = 'S' or ((a.cd_motivo_glosa IS NOT NULL AND a.cd_motivo_glosa::text <> '') and coalesce(a.ie_acao_glosa,c.ie_acao_glosa) <> 'A')) and a.nr_seq_ret_item		= nr_seq_ret_item_w   and a.nr_seq_matpaci		= d.nr_sequencia and (coalesce(ie_somente_motivo_w,'N') = 'N' or (a.cd_motivo_glosa IS NOT NULL AND a.cd_motivo_glosa::text <> ''));

					end if;

				end if;

				if (coalesce(qt_itens_guia_w,1)	> 0) then

					select	nextval('lote_audit_hist_guia_seq')
					into STRICT	nr_seq_lote_guia_w
					;

					select	coalesce(max('S'),'N')
					into STRICT	ie_guia_sem_saldo_w
					from	convenio_retorno_item a
					where	a.nr_seq_retorno	= nr_seq_retorno_p
					and	a.nr_interno_conta	= nr_interno_conta_w
					and	a.cd_autorizacao	= cd_autorizacao_w
					and	coalesce(a.vl_amenor,0)	= 0;

					insert	into lote_audit_hist_guia(cd_autorizacao,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						nr_interno_conta,
						nr_seq_lote_hist,
						nr_sequencia,
						nr_seq_retorno,
						ie_guia_sem_saldo,
						vl_saldo_guia,
						ds_observacao,
						dt_pagamento)
					values (cd_autorizacao_w,
						clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						nm_usuario_p,
						nr_interno_conta_w,
						nr_seq_lote_hist_p,
						nr_seq_lote_guia_w,
						nr_seq_retorno_p,
						ie_guia_sem_saldo_w,
						vl_guia_w,
						ds_observacao_w,
						dt_pagamento_w);

					if (coalesce(ie_gerar_itens_p,'S')	= 'S') then

						CALL gerar_lote_audit_hist_item(nr_seq_retorno_p,nr_seq_ret_item_w,nr_seq_lote_guia_w,nm_usuario_p);

					end if;

				end if;
			end if;

		end if;

	end loop;
	close c01;

elsif (nr_analise_w > 1) then			/* usado na opcao "Gerar itens recursados" da GRG */
	ie_gerar_acao_w := obter_param_usuario(69, 29, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_acao_w);
	ie_gerar_resposta_w := obter_param_usuario(69, 30, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_resposta_w);
	ie_gerar_justificativa_w := obter_param_usuario(69, 31, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_justificativa_w);
	

	select	max(a.nr_sequencia)		/* obter a analise anterior */
	into STRICT	nr_seq_lote_hist_w
	from	lote_audit_hist a
	where	a.nr_sequencia		<> nr_seq_lote_hist_p
	and	a.nr_seq_lote_audit	= nr_seq_lote_w;

	open c03;
	loop
	fetch c03 into
		nr_seq_guia_ant_w,
		cd_autorizacao_w,
		nr_interno_conta_w,
		nr_seq_retorno_w,
		ie_guia_sem_saldo_w,
		vl_guia_w,
		dt_pagamento_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */

		select	sum(a.vl_amenor)
		into STRICT	vl_amenor_w
		from	convenio_retorno_item a
		where	a.nr_interno_conta	= nr_interno_conta_w
		and	a.cd_autorizacao	= cd_autorizacao_w;

		select	nextval('lote_audit_hist_guia_seq')
		into STRICT	nr_seq_lote_guia_w
		;

		insert	into lote_audit_hist_guia(cd_autorizacao,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			nr_interno_conta,
			nr_seq_lote_hist,
			nr_sequencia,
			nr_seq_retorno,
			ie_guia_sem_saldo,
			vl_saldo_guia,
			dt_pagamento)
		values (cd_autorizacao_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			nr_interno_conta_w,
			nr_seq_lote_hist_p,
			nr_seq_lote_guia_w,
			nr_seq_retorno_w,
			ie_guia_sem_saldo_w,
			vl_guia_w,
			dt_pagamento_w);

		if (coalesce(ie_gerar_itens_p,'S')	= 'S') then

			/* select	lote_audit_hist_item_seq.nextval
			into	nr_seq_item_w
			from	dual;  */

			
			
			/*	S              |Sempre gerar acao de glosa
				N              |Nao copiar a acao da glosa existente nos itens da ultima analise na GRG
				G              |Nao gerar a acao de glosa existente nos itens glosados do 'Retorno convenio'
				A              |Nao gerar acao de glosa ao utilizar opcao 'Gerar lote de reapresentacao GRG' */
			
			if (ie_gerar_acao_w = 'A') then
				ie_gerar_acao_w := 'N';
			end if;
			
			insert	into lote_audit_hist_item(ds_observacao,
				dt_atualizacao,
				dt_historico,
				ie_status,
				nm_usuario,
				nr_seq_guia,
				nr_seq_matpaci,
				nr_seq_propaci,
				nr_seq_ret_glosa,
				nr_seq_ret_item,
				nr_sequencia,
				vl_glosa,
				vl_amenor,
				vl_pago,
				vl_acatado,
				qt_item,
				vl_saldo_amenor,
				vl_saldo,
				vl_glosa_informada,
				cd_setor_responsavel,
				cd_motivo_glosa,
				cd_resposta,
				nr_seq_lote,
				nr_seq_partic,
				ie_acao_glosa,
        nr_sequencia_item)
			(SELECT	CASE WHEN ie_gerar_justificativa_w='N' THEN null  ELSE a.ds_observacao END ,
				clock_timestamp(),
				clock_timestamp(),
				'A',
				nm_usuario_p,
				nr_seq_lote_guia_w,
				a.nr_seq_matpaci,
				a.nr_seq_propaci,
				a.nr_seq_ret_glosa,
				a.nr_seq_ret_item,
				nextval('lote_audit_hist_item_seq'),
				0,
				a.vl_amenor,
				a.vl_pago,
				a.vl_acatado,
				a.qt_item,
				a.vl_amenor,
				a.vl_amenor,
				a.vl_amenor,
				a.cd_setor_responsavel,
				a.cd_motivo_glosa,
				CASE WHEN ie_gerar_resposta_w='N' THEN null  ELSE a.cd_resposta END ,
				nr_seq_lote_hist_p,
				a.nr_seq_partic,
				CASE WHEN ie_gerar_acao_w='N' THEN null  ELSE a.ie_acao_glosa END ,
        nr_sequencia_item
			from	lote_audit_hist_item a
			where	a.nr_seq_guia	= nr_seq_guia_ant_w
			and	a.vl_amenor	> 0);
			
		end if;

	end loop;
	close c03;

end if;

ds_retorno_p	:= ds_retorno_w;

if (coalesce(ie_permite_gerar_analise_w,'N') <> 'S') then
	commit;
	CALL ATUAL_JUS_LOTE_AUDIT_HIST_ITEM(nr_seq_lote_guia_w, nm_usuario_p);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lote_audit_hist (nr_seq_lote_hist_p bigint, nm_usuario_p text, nr_seq_retorno_p bigint, ie_gerar_itens_p text, ie_guia_sem_saldo_p text, ie_gerar_lotes_p text default 'N', ds_retorno_p INOUT text DEFAULT NULL) FROM PUBLIC;
