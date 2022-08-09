-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_autor_convenio (nr_prescricao_p bigint, nr_seq_proc_prescr_p bigint, nr_seq_mat_prescr_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_autor_w		bigint;
nr_seq_autor_destino_w		bigint;
nr_seq_item_autor_w		bigint;
qt_solicitada_w			bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_estagio_cancel_w		bigint	:= null;
nr_seq_estagio_pend_canc_w	bigint	:= null;
cd_material_w			bigint;
ie_interno_w			varchar(3);
qt_proc_autorizado_w		integer;
qt_mat_autorizado_w		integer;
nr_seq_novo_item_autor_w	bigint;	
qt_autorizacao_w		bigint;
cd_estabelecimento_w		smallint;
ie_cancelar_autor_prescr_w	varchar(15);

BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_estagio_cancel_w
from	estagio_autorizacao
where	ie_situacao	= 'A'
and	ie_interno	= '70'
and	OBTER_EMPRESA_ESTAB(wheb_usuario_pck.get_cd_estabelecimento) = cd_empresa;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_estagio_pend_canc_w
from	estagio_autorizacao
where	ie_situacao	= 'A'
and	ie_interno	= '60'
and	OBTER_EMPRESA_ESTAB(wheb_usuario_pck.get_cd_estabelecimento) = cd_empresa;

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

select	coalesce(max(ie_cancelar_autor_prescr),'N')
into STRICT	ie_cancelar_autor_prescr_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_w;

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_proc_prescr_p IS NOT NULL AND nr_seq_proc_prescr_p::text <> '') then

	select	coalesce(max(nr_sequencia_autor),0),
		coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_autor_w,
		nr_seq_item_autor_w
	from	procedimento_autorizado
	where	nr_prescricao		= nr_prescricao_p
	and	nr_seq_prescricao	= nr_seq_proc_prescr_p;
		
	if (nr_sequencia_autor_w > 0) then

		select	max(b.ie_interno)
		into STRICT	ie_interno_w
		from	estagio_autorizacao b,
			autorizacao_convenio a
		where	a.nr_seq_estagio	= b.nr_sequencia
		and	a.nr_sequencia		= nr_sequencia_autor_w;	

		/* Se ainda nao estiver encaminhada ou autorizada */

		if	((ie_interno_w not in ('5','10')) or coalesce(nr_seq_estagio_pend_canc_w,0) = 0) and (nr_seq_estagio_cancel_w > 0) and (coalesce(ie_cancelar_autor_prescr_w,'S')  <> 'C') then

			select	cd_procedimento,
				ie_origem_proced,
				qt_procedimento
			into STRICT	cd_procedimento_w,
				ie_origem_proced_w,
				qt_solicitada_w
			from	prescr_procedimento
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_seq_proc_prescr_p;

			select	coalesce(max(a.nr_sequencia),0)
			into STRICT	nr_seq_autor_destino_w
			from	estagio_autorizacao b,
				autorizacao_convenio a
			where	a.nr_seq_estagio	= b.nr_sequencia
			and	a.nr_prescricao		= nr_prescricao_p
			and	b.ie_interno		= '70'
			and	not exists (SELECT	1
					    from	procedimento_autorizado x
					    where	x.nr_sequencia_autor	= a.nr_sequencia
					    and		x.cd_procedimento	= cd_procedimento_w
					    and		x.ie_origem_proced	= ie_origem_proced_w);
		
			if (nr_seq_autor_destino_w = 0) then		
				nr_seq_autor_destino_w := duplicar_autorizacao_convenio(nr_sequencia_autor_w, nm_usuario_p, nr_seq_autor_destino_w, 'N', 'N');
			end if;

			CALL transferir_proc_mat_autor(nr_sequencia_autor_w,
						  nr_seq_autor_destino_w,
						  nr_seq_item_autor_w,
						  qt_solicitada_w,
						  null,
						  null,
						  nm_usuario_p,
						  'N');

			update	autorizacao_convenio
			set	nr_seq_estagio	= nr_seq_estagio_cancel_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_autor_destino_w;

			select	max(nr_sequencia)
			into STRICT	nr_seq_novo_item_autor_w
			from	procedimento_autorizado
			where	cd_procedimento		= cd_procedimento_w
			and	ie_origem_proced	= ie_origem_proced_w
			and	nr_sequencia_autor	= nr_seq_autor_destino_w;
	
			if (nr_seq_novo_item_autor_w IS NOT NULL AND nr_seq_novo_item_autor_w::text <> '') then				
				update	procedimento_autorizado
				set	ds_observacao	= CASE WHEN ds_observacao = NULL THEN null  ELSE substr(ds_observacao,1,1800) || chr(13) || chr(10) END  ||
								wheb_mensagem_pck.get_texto(310536,'nr_sequencia_autor_w='|| nr_sequencia_autor_w ),
								/*Procedimento desdobrado e cancelado pelo sistema devido a suspensao na prescricao.
								Originado pela autorizacao: #@nr_sequencia_autor_w#@*/
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= nm_usuario_p
				where	nr_sequencia	= nr_seq_novo_item_autor_w;
			end if;

			/* Verificar se a autorizacao ficou vazia para cancelar */

			select	count(*)
			into STRICT	qt_proc_autorizado_w
			from	procedimento_autorizado
			where	nr_sequencia_autor	= nr_sequencia_autor_w;

			select	count(*)
			into STRICT	qt_mat_autorizado_w
			from	material_autorizado
			where	nr_sequencia_autor	= nr_sequencia_autor_w;
			
			select	count(*)
			into STRICT	qt_autorizacao_w
			from	autorizacao_convenio
			where	nr_sequencia		= nr_sequencia_autor_w;

			if (qt_proc_autorizado_w = 0) and (qt_mat_autorizado_w = 0) and (coalesce(qt_autorizacao_w,0) > 0) then				
				CALL atualizar_autorizacao_convenio(nr_sequencia_autor_w,nm_usuario_p,nr_seq_estagio_cancel_w,'N','N','S');

				update	autorizacao_convenio
				set	ds_observacao	= CASE WHEN ds_observacao = NULL THEN null  ELSE substr(ds_observacao,1,1800) || chr(13) || chr(10) END  ||
							wheb_mensagem_pck.get_texto(310540,'dt_atual_w='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(clock_timestamp(), 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||'nr_prescricao_p='||nr_prescricao_p),				
							/*'Autorizacao cancelada pelo sistema em ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') ||
							' por todos os itens da prescricao ' ||  nr_prescricao_p || ' terem sido suspensos/cancelados.',*/
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= nm_usuario_p
				where	nr_sequencia	= nr_sequencia_autor_w;	
			end if;

		/* Se ja esta encaminhada/autorizada */

		elsif (nr_seq_estagio_pend_canc_w > 0) and (coalesce(ie_cancelar_autor_prescr_w,'S') <> 'C') then	
			
			CALL atualizar_autorizacao_convenio(nr_sequencia_autor_w,nm_usuario_p,nr_seq_estagio_pend_canc_w,'N','N','S');

			update	autorizacao_convenio
			set	ds_observacao	= CASE WHEN ds_observacao = NULL THEN null  ELSE substr(ds_observacao,1,1800) || chr(13) || chr(10) END  ||
						wheb_mensagem_pck.get_texto(310541,'dt_atual_w='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(clock_timestamp(), 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)),
						/*'Autorizacao alterada para "Pendente de cancelamento" pelo sistema em ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') ||
						' por haver um ou mais itens da prescricao que foram suspensos. ',*/
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_sequencia_autor_w;		
		elsif (coalesce(ie_cancelar_autor_prescr_w,'S') = 'C') and (nr_seq_estagio_cancel_w > 0) then
			
			CALL atualizar_autorizacao_convenio(nr_sequencia_autor_w,nm_usuario_p,nr_seq_estagio_cancel_w,'N','N','S');
			
		end if;	
	end if;

elsif (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_mat_prescr_p IS NOT NULL AND nr_seq_mat_prescr_p::text <> '') then

	select	coalesce(max(nr_sequencia_autor),0),
		coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_autor_w,
		nr_seq_item_autor_w
	from	material_autorizado
	where	nr_prescricao		= nr_prescricao_p
	and	nr_seq_prescricao	= nr_seq_mat_prescr_p;

	if (nr_sequencia_autor_w > 0) then

		select	max(b.ie_interno)
		into STRICT	ie_interno_w
		from	estagio_autorizacao b,
			autorizacao_convenio a
		where	a.nr_seq_estagio	= b.nr_sequencia
		and	a.nr_sequencia		= nr_sequencia_autor_w;	

		/* Se ainda nao estiver encaminhada ou autorizada */

		if	((ie_interno_w not in ('5','10')) or coalesce(nr_seq_estagio_pend_canc_w,0) = 0) and (nr_seq_estagio_cancel_w > 0) and (coalesce(ie_cancelar_autor_prescr_w,'S') <> 'C') then
			select	cd_material,
				qt_material
			into STRICT	cd_material_w,
				qt_solicitada_w
			from	prescr_material
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_seq_mat_prescr_p;
		
			select	coalesce(max(a.nr_sequencia),0)
			into STRICT	nr_seq_autor_destino_w
			from	estagio_autorizacao b,
				autorizacao_convenio a
			where	a.nr_seq_estagio	= b.nr_sequencia
			and	a.nr_prescricao		= nr_prescricao_p
			and	b.ie_interno		= '70'
			and	not exists (SELECT	1
					    from	material_autorizado x
					    where	x.nr_sequencia_autor	= a.nr_sequencia
					    and		x.cd_material		= cd_material_w);
		
			if (nr_seq_autor_destino_w = 0) then		
				nr_seq_autor_destino_w := duplicar_autorizacao_convenio(nr_sequencia_autor_w, nm_usuario_p, nr_seq_autor_destino_w, 'N', 'N');
			end if;

			CALL transferir_proc_mat_autor(nr_sequencia_autor_w,
						  nr_seq_autor_destino_w,
						  null,
						  null,
						  nr_seq_item_autor_w,
						  qt_solicitada_w,
						  nm_usuario_p,
						  'N');

			update	autorizacao_convenio
			set	nr_seq_estagio	= nr_seq_estagio_cancel_w
			where	nr_sequencia	= nr_seq_autor_destino_w;

			select	max(nr_sequencia)
			into STRICT	nr_seq_novo_item_autor_w
			from	material_autorizado
			where	cd_material		= cd_material_w
			and	nr_sequencia_autor	= nr_seq_autor_destino_w;

			if (nr_seq_novo_item_autor_w IS NOT NULL AND nr_seq_novo_item_autor_w::text <> '') then
	
				update	material_autorizado
				set	ds_observacao	= substr(CASE WHEN ds_observacao = NULL THEN null  ELSE substr(ds_observacao,1,1800) || chr(13) || chr(10) END  ||
								wheb_mensagem_pck.get_texto(310542,'nr_sequencia_autor_w='||nr_sequencia_autor_w),1,2000),

								/*'Material desdobrado e cancelado pelo sistema devido a suspensao na prescricao.' ||
								chr(13) || chr(10) || 'Originado pela autorizacao: ' || nr_sequencia_autor_w*/
					dt_atualizacao 	= clock_timestamp(),
					nm_usuario	= nm_usuario_p
				where	nr_sequencia	= nr_seq_novo_item_autor_w;
			end if;

			/* Verificar se a autorizacao ficou vazia para excluir */

			select	count(*)
			into STRICT	qt_proc_autorizado_w
			from	procedimento_autorizado
			where	nr_sequencia_autor	= nr_sequencia_autor_w;

			select	count(*)
			into STRICT	qt_mat_autorizado_w
			from	material_autorizado
			where	nr_sequencia_autor	= nr_sequencia_autor_w;

			select	count(*)
			into STRICT	qt_autorizacao_w
			from	autorizacao_convenio
			where	nr_sequencia		= nr_sequencia_autor_w;

			if (qt_proc_autorizado_w = 0) and (qt_mat_autorizado_w = 0) and (qt_autorizacao_w > 0) then
				CALL atualizar_autorizacao_convenio(nr_sequencia_autor_w,nm_usuario_p,nr_seq_estagio_cancel_w,'N','N','S');

				update	autorizacao_convenio
				set	ds_observacao	= CASE WHEN ds_observacao = NULL THEN null  ELSE substr(ds_observacao,1,1800) || chr(13) || chr(10) END  ||
							wheb_mensagem_pck.get_texto(310544,'dt_atual_w='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(clock_timestamp(), 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||'nr_prescricao_p='||nr_prescricao_p),				
							/*'Autorizacao cancelada pelo sistema em ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') ||
							' por todos os itens da prescricao ' || nr_prescricao_p || ' terem sido suspensos/cancelados ',*/
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= nm_usuario_p
				where	nr_sequencia	= nr_sequencia_autor_w;	
			end if;

		/* Se ja esta encaminhada/autorizada */

		elsif (nr_seq_estagio_pend_canc_w > 0) and (coalesce(ie_cancelar_autor_prescr_w,'S') <> 'C')then
		
			CALL atualizar_autorizacao_convenio(nr_sequencia_autor_w,nm_usuario_p,nr_seq_estagio_pend_canc_w,'N','N','S');

			update	autorizacao_convenio
			set	ds_observacao	= CASE WHEN ds_observacao = NULL THEN null  ELSE substr(ds_observacao,1,1800) || chr(13) || chr(10) END  ||
						wheb_mensagem_pck.get_texto(310541,'dt_atual_w='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(clock_timestamp(), 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)),
						/*'Autorizacao alterada para "Pendente de cancelamento" pelo sistema em ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') ||
						' por haver um ou mais itens da prescricao que foram suspensos. ',*/
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_sequencia_autor_w;	

		elsif (coalesce(ie_cancelar_autor_prescr_w,'S') = 'C') and (nr_seq_estagio_cancel_w > 0) then
			
			CALL atualizar_autorizacao_convenio(nr_sequencia_autor_w,nm_usuario_p,nr_seq_estagio_cancel_w,'N','N','S');
			

		end if;		
	end if;

end if;

/* Nao pode dar commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_autor_convenio (nr_prescricao_p bigint, nr_seq_proc_prescr_p bigint, nr_seq_mat_prescr_p bigint, nm_usuario_p text) FROM PUBLIC;
