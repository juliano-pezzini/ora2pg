-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_proc_mat_autor (nr_seq_autor_origem_p bigint, nr_seq_autor_destino_p bigint, nr_seq_proc_autor_p bigint, qt_procedimento_p bigint, nr_seq_mat_autor_p bigint, qt_material_p bigint, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


nr_seq_proc_novo_w	bigint;
nr_seq_mat_novo_w	bigint;
qt_solic_proc_w		bigint;
qt_autor_proc_w		bigint;
qt_solic_mat_w		double precision;
qt_autor_mat_w		double precision;
nr_seq_autorizacao_w	bigint;
qt_proc_autor_w		double precision;
qt_mat_autor_w		double precision;
ie_exclui_autor_antiga_w	varchar(10);
qt_proc_autor_transf_w	bigint;
qt_autorizada_proc_w	bigint;
qt_mat_autor_transf_w	double precision;
qt_autorizada_mat_w	double precision;
nr_seq_item_conta_w	bigint;
qt_item_conta_w		bigint;
nr_seq_novo_item_gerado_w	bigint;
ie_desdobrar_itens_conta_w	varchar(15) := 'N';
nr_prescricao_w			bigint;
nr_prescricao_mat_w		bigint;	
nr_seq_prescricao_w		bigint;


BEGIN
ie_exclui_autor_antiga_w := obter_param_usuario(3004, 69, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.Get_cd_estabelecimento, ie_exclui_autor_antiga_w);
ie_desdobrar_itens_conta_w := obter_param_usuario(3004, 162, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.Get_cd_estabelecimento, ie_desdobrar_itens_conta_w);

if (nr_seq_autor_destino_p IS NOT NULL AND nr_seq_autor_destino_p::text <> '') then

	select	nr_seq_autorizacao
	into STRICT	nr_seq_autorizacao_w
	from	autorizacao_convenio
	where	nr_sequencia	= nr_seq_autor_destino_p;

	if (coalesce(nr_seq_proc_autor_p,0) > 0) and (qt_procedimento_p > 0) then

		select	nextval('procedimento_autorizado_seq')
		into STRICT	nr_seq_proc_novo_w
		;

		select	qt_autorizada,
			nr_prescricao,
			nr_seq_prescricao
		into STRICT	qt_autorizada_proc_w,
			nr_prescricao_w,
			nr_seq_prescricao_w
		from 	procedimento_autorizado
		where	nr_sequencia	= nr_seq_proc_autor_p;

		if (coalesce(qt_procedimento_p,0) >= qt_autorizada_proc_w) then
			qt_proc_autor_transf_w	:= qt_autorizada_proc_w;
		else
			qt_proc_autor_transf_w	:= coalesce(qt_procedimento_p,0);
		end if;

		insert into procedimento_autorizado(nr_sequencia,
			nr_sequencia_autor,
			nr_atendimento,
			nr_seq_autorizacao,
			cd_procedimento,
			ie_origem_proced,
			qt_solicitada,
			qt_autorizada,
			ds_observacao,
			vl_autorizado,
			nr_prescricao,
			nr_seq_prescricao,
			nm_usuario_aprov,
			dt_aprovacao,
			nm_usuario,
			dt_atualizacao,
			nr_seq_proc_interno,
			nr_seq_agenda,
			nr_seq_agenda_proc)
		SELECT	nr_seq_proc_novo_w,
			nr_seq_autor_destino_p,
			nr_atendimento,
			nr_seq_autorizacao_w,
			cd_procedimento,
			ie_origem_proced,
			coalesce(qt_procedimento_p,0),
			qt_proc_autor_transf_w,
			ds_observacao,
			vl_autorizado,
			nr_prescricao,
			nr_seq_prescricao,
			nm_usuario_aprov,
			dt_aprovacao,
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_proc_interno,
			nr_seq_agenda,
			nr_seq_agenda_proc
		from	procedimento_autorizado
		where	nr_sequencia = nr_seq_proc_autor_p;

		update	procedimento_autorizado
		set	qt_solicitada	= qt_solicitada - qt_procedimento_p,
			qt_autorizada	= qt_autorizada - qt_proc_autor_transf_w,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_proc_autor_p;
		
		if (coalesce(ie_desdobrar_itens_conta_w,'N') = 'S') then
			begin
			select	max(a.nr_sequencia),
				max(a.qt_procedimento)
			into STRICT	nr_seq_item_conta_w,
				qt_item_conta_w
			from	procedimento_paciente a,
				conta_paciente b
			where	a.nr_seq_proc_autor = nr_seq_proc_autor_p
			and	b.nr_interno_conta = a.nr_interno_conta
			and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
			and	b.ie_status_acerto = 1;
			exception
			when others then
				nr_seq_item_conta_w := 0;
				qt_item_conta_w	 := 0;
			end;
			
			if (coalesce(nr_seq_item_conta_w,0) = 0) then
				begin
				select	max(a.nr_sequencia),
					max(a.qt_procedimento)
				into STRICT	nr_seq_item_conta_w,
					qt_item_conta_w
				from	procedimento_paciente a,
					conta_paciente b
				where	a.nr_prescricao = nr_prescricao_w
				and	a.nr_sequencia_prescricao = nr_seq_prescricao_w
				and	b.nr_interno_conta = a.nr_interno_conta
				and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
				and	b.ie_status_acerto = 1;
				exception
				when others then
					nr_seq_item_conta_w := 0;
					qt_item_conta_w	 := 0;
				end;
			end if;
			
			if (nr_seq_item_conta_w > 0) then
				begin
				nr_seq_novo_item_gerado_w := Duplicar_Proc_Paciente_autor(nr_seq_item_conta_w, qt_procedimento_p, nm_usuario_p, nr_seq_proc_novo_w, nr_seq_novo_item_gerado_w);
				
				if (coalesce(nr_seq_novo_item_gerado_w,0) > 0) then
					
					CALL atualiza_preco_proc_amb(nr_seq_novo_item_gerado_w,nm_usuario_p);
					
					update	procedimento_paciente
					set	qt_procedimento = qt_procedimento - qt_procedimento_p,
						nm_usuario	= nm_usuario_p,
						dt_atualizacao	= clock_timestamp()
					where	nr_sequencia 	= nr_seq_item_conta_w;
					
					CALL atualiza_preco_proc_amb(nr_seq_item_conta_w,nm_usuario_p);
				end if;
				end;
			end if;

		end if;
		
		select	qt_solicitada,
			qt_autorizada
		into STRICT	qt_solic_proc_w,
			qt_autor_proc_w
		from	procedimento_autorizado
		where	nr_sequencia	= nr_seq_proc_autor_p;

		if (qt_solic_proc_w = 0) and (qt_autor_proc_w = 0) then
			update	procedimento_paciente
			set	nr_seq_proc_autor	= nr_seq_proc_novo_w,
				dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_seq_proc_autor	= nr_seq_proc_autor_p;

			delete	from	procedimento_autorizado
			where	nr_sequencia	= nr_seq_proc_autor_p;
		end if;

	elsif (nr_seq_mat_autor_p > 0) and (qt_material_p > 0) then

		select	nextval('material_autorizado_seq')
		into STRICT	nr_seq_mat_novo_w
		;

		select	qt_autorizada,
			nr_prescricao,
			nr_seq_prescricao
		into STRICT	qt_mat_autor_transf_w,
			nr_prescricao_mat_w,
			nr_seq_prescricao_w
		from 	material_autorizado
		where	nr_sequencia	= nr_seq_mat_autor_p;

		if (coalesce(qt_material_p,0) >= qt_mat_autor_transf_w) then
			qt_proc_autor_transf_w	:= qt_mat_autor_transf_w;
		else
			qt_proc_autor_transf_w	:= coalesce(qt_material_p,0);
		end if;

		insert into material_autorizado(nr_sequencia,
			nr_sequencia_autor,
			nr_atendimento,
			nr_seq_autorizacao,
			cd_material,
			qt_solicitada,
			qt_autorizada,
			ds_observacao,
			nm_usuario_aprov,
			dt_aprovacao,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			vl_unitario,
			cd_cgc_fabricante,
			nr_seq_fabricante,
			ds_mat_convenio,
			ie_valor_conta,
			nr_seq_opme,
			vl_cotado,
			nr_prescricao,
			nr_seq_prescricao,
			pr_adicional)
		SELECT	nr_seq_mat_novo_w,
			nr_seq_autor_destino_p,
			nr_atendimento,
			nr_seq_autorizacao_w,
			cd_material,
			coalesce(qt_material_p,0),
			qt_proc_autor_transf_w,
			ds_observacao,
			nm_usuario_aprov,
			dt_aprovacao,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			vl_unitario,
			cd_cgc_fabricante,
			nr_seq_fabricante,
			ds_mat_convenio,
			ie_valor_conta,
			nr_seq_opme,
			vl_cotado,
			nr_prescricao,
			nr_seq_prescricao,
			pr_adicional
		from	material_autorizado
		where	nr_sequencia = nr_seq_mat_autor_p;

		update	material_autorizado
		set	qt_solicitada	= qt_solicitada - qt_material_p,
			qt_autorizada	= qt_autorizada - qt_proc_autor_transf_w,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_mat_autor_p;

		if (coalesce(ie_desdobrar_itens_conta_w,'N') = 'S') then
			begin
			select	max(a.nr_sequencia),
				max(a.qt_material)
			into STRICT	nr_seq_item_conta_w,
				qt_item_conta_w
			from	material_atend_paciente a,
				conta_paciente b
			where	a.nr_seq_mat_autor = nr_seq_mat_autor_p
			and	a.nr_interno_conta = b.nr_interno_conta
			and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
			and	b.ie_status_acerto = 1;
			exception
			when others then
				nr_seq_item_conta_w := 0;
				qt_item_conta_w	 := 0;
			end;
			
			update	material_atend_paciente
			set	nr_seq_mat_autor  = nr_seq_mat_autor_p,
				dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia = nr_seq_item_conta_w
			and	coalesce(nr_seq_mat_autor::text, '') = '';
				
			if (coalesce(nr_seq_item_conta_w,0) = 0) then
				begin
				select	max(a.nr_sequencia),
					max(a.qt_material)
				into STRICT	nr_seq_item_conta_w,
					qt_item_conta_w
				from	material_atend_paciente a,
					conta_paciente b
				where	a.nr_prescricao = nr_prescricao_mat_w
				and	a.nr_sequencia_prescricao = nr_seq_prescricao_w
				and	a.nr_interno_conta = b.nr_interno_conta
				and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
				and	b.ie_status_acerto = 1;
				exception
				when others then
					nr_seq_item_conta_w := 0;
					qt_item_conta_w	 := 0;
				end;
				
				update	material_atend_paciente
				set	nr_seq_mat_autor  = nr_seq_mat_autor_p,
					dt_atualizacao 	= clock_timestamp(),
					nm_usuario	= nm_usuario_p
				where	nr_sequencia = nr_seq_item_conta_w
				and	coalesce(nr_seq_mat_autor::text, '') = '';
				
			end if;
			
			if (nr_seq_item_conta_w > 0) then
				begin
				nr_seq_novo_item_gerado_w := Duplicar_Mat_Paciente_autor(nr_seq_item_conta_w, nm_usuario_p, nr_seq_mat_novo_w, qt_material_p, 'S', nr_seq_novo_item_gerado_w);
			
				if (coalesce(nr_seq_novo_item_gerado_w,0) > 0) then
					
					CALL atualiza_preco_material(nr_seq_novo_item_gerado_w,nm_usuario_p);
					
					update	material_atend_paciente
					set	qt_material 	= qt_material - qt_material_p,
						nm_usuario	= nm_usuario_p,
						dt_atualizacao	= clock_timestamp()
					where	nr_sequencia 	= nr_seq_item_conta_w;
				
					CALL atualiza_preco_material(nr_seq_item_conta_w,nm_usuario_p);
				end if;
				end;
			end if;

		end if;
		
		select	qt_solicitada,
			qt_autorizada
		into STRICT	qt_solic_mat_w,
			qt_autor_mat_w
		from	material_autorizado
		where	nr_sequencia	= nr_seq_mat_autor_p;

		if (qt_solic_mat_w = 0) and (qt_autor_mat_w = 0) then

			update	material_atend_paciente
			set	nr_seq_mat_autor	= nr_seq_mat_novo_w,
				dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_seq_mat_autor	= nr_seq_mat_autor_p;

			delete	from	 material_autorizado
			where	nr_sequencia	= nr_seq_mat_autor_p;
		end if;
	end if;

	update	autorizacao_convenio
	set	nr_seq_autor_desdob	= nr_seq_autor_origem_p,
		dt_atualizacao 		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_autor_destino_p
	and	coalesce(nr_seq_autor_desdob::text, '') = '';
	
end if;

select 	coalesce(count(*),0)
into STRICT 	qt_proc_autor_w
from 	procedimento_autorizado
where 	nr_sequencia_autor	= nr_seq_autor_origem_p;

select 	coalesce(count(*),0)
into STRICT 	qt_mat_autor_w
from 	material_autorizado
where 	nr_sequencia_autor	= nr_seq_autor_origem_p;

if (nr_seq_autor_origem_p IS NOT NULL AND nr_seq_autor_origem_p::text <> '') and (qt_proc_autor_w = 0) and (qt_mat_autor_w = 0) then

	update	autorizacao_convenio_hist
	set	nr_seq_autor_origem	= nr_sequencia_autor,
		nr_sequencia_autor	= nr_seq_autor_destino_p
	where	nr_sequencia_autor	= nr_seq_autor_origem_p;

end if;

/*lhalves OS 236457 em 30/07/2010*/

if (nr_seq_autor_origem_p IS NOT NULL AND nr_seq_autor_origem_p::text <> '') and (coalesce(ie_exclui_autor_antiga_w,'N') = 'S') then

	if (qt_proc_autor_w = 0) and (qt_mat_autor_w = 0) then
		
		update	autorizacao_convenio
		set	nr_seq_autor_desdob	 = NULL,
			dt_atualizacao 		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_autor_desdob	= nr_seq_autor_origem_p;

		delete 	from 	autor_convenio_evento
		where	nr_sequencia_autor  	= nr_seq_autor_origem_p;
		
		delete from autorizacao_conv_etapa
		where	nr_seq_autor_conv	= nr_seq_autor_origem_p;

		delete 	from 	autorizacao_convenio
		where	nr_sequencia		= nr_seq_autor_origem_p;
	end if;

end if;

if (ie_commit_p = 'S') then
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_proc_mat_autor (nr_seq_autor_origem_p bigint, nr_seq_autor_destino_p bigint, nr_seq_proc_autor_p bigint, qt_procedimento_p bigint, nr_seq_mat_autor_p bigint, qt_material_p bigint, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;
