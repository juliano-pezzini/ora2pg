-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agrupar_autorizacao_convenio (nr_seq_autor_origem_p bigint, nr_seq_autor_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_proc_ant_w		bigint;
nr_seq_proc_novo_w	bigint;
nr_seq_mat_ant_w		bigint;
nr_seq_mat_novo_w	bigint;
nr_seq_autorizacao_w	bigint;
qt_proc_autor_w		double precision;
qt_mat_autor_w		double precision;
qt_proc_autor_origem_w	double precision;
qt_mat_autor_origem_w	double precision;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_material_w		integer;
nr_seq_proc_destino_w	bigint;
nr_seq_mat_destino_w	bigint;
nr_atendimento_w		bigint;
ds_tipo_autor_origem_w	varchar(255);
ie_exclui_autor_antiga_w	varchar(10);
nr_seq_proc_interno_w		proc_interno.nr_sequencia%type;

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_procedimento,
	ie_origem_proced,
	coalesce(qt_solicitada,0),
	coalesce(nr_seq_proc_interno,0)
from 	procedimento_autorizado
where	nr_sequencia_autor	= nr_seq_autor_origem_p;

c02 CURSOR FOR
SELECT	nr_sequencia,
	cd_material,
	coalesce(qt_solicitada,0)
from 	material_autorizado
where	nr_sequencia_autor	= nr_seq_autor_origem_p;


BEGIN

ie_exclui_autor_antiga_w := obter_param_usuario(3004, 69, obter_perfil_ativo, nm_usuario_p, 0, ie_exclui_autor_antiga_w);

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from 	autorizacao_convenio
where	nr_sequencia	= nr_seq_autor_destino_p;

select	substr(obter_valor_dominio(1377,ie_tipo_autorizacao),1,255)
into STRICT	ds_tipo_autor_origem_w
from 	autorizacao_convenio
where	nr_sequencia	= nr_seq_autor_origem_p;

if (nr_seq_autor_destino_p IS NOT NULL AND nr_seq_autor_destino_p::text <> '') and (nr_seq_autor_origem_p IS NOT NULL AND nr_seq_autor_origem_p::text <> '') and (nr_seq_autor_origem_p <> nr_seq_autor_destino_p) then

	select	max(nr_seq_autorizacao)
	into STRICT	nr_seq_autorizacao_w
	from	autorizacao_convenio
	where	nr_sequencia	= nr_seq_autor_destino_p;

	open c01;
	loop
	fetch c01 into
		nr_seq_proc_ant_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		qt_proc_autor_origem_w,
		nr_seq_proc_interno_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		select	max(nr_sequencia)
		into STRICT	nr_seq_proc_destino_w
		from 	procedimento_autorizado
		where	nr_sequencia_autor	= nr_seq_autor_destino_p
		and	cd_procedimento		= cd_procedimento_w
		and 	ie_origem_proced	= ie_origem_proced_w
		and	coalesce(nr_seq_proc_interno,nr_seq_proc_interno_w)	= nr_seq_proc_interno_w;

		if (coalesce(nr_seq_proc_destino_w::text, '') = '') then

			select	nextval('procedimento_autorizado_seq')
			into STRICT	nr_seq_proc_novo_w
			;

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
				nr_seq_proc_interno)
			SELECT	nr_seq_proc_novo_w,
				nr_seq_autor_destino_p,
				nr_atendimento,
				nr_seq_autorizacao_w,
				cd_procedimento,
				ie_origem_proced,
				qt_solicitada,
				0,
				ds_observacao,
				vl_autorizado,
				nr_prescricao,
				nr_seq_prescricao,
				nm_usuario_aprov,
				dt_aprovacao,
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_proc_interno
			from	procedimento_autorizado
			where	nr_sequencia 	= nr_seq_proc_ant_w;

			update	procedimento_paciente
			set	nr_seq_proc_autor	= nr_seq_proc_novo_w
			where	nr_seq_proc_autor	= nr_seq_proc_ant_w;

			delete	from	procedimento_autorizado
			where	nr_sequencia	= nr_seq_proc_ant_w;

		else
			update	procedimento_autorizado
			set	qt_solicitada		= qt_solicitada + qt_proc_autor_origem_w,
				nm_usuario		= nm_usuario_p
			where	nr_sequencia		= nr_seq_proc_destino_w
			and	nr_sequencia_autor	= nr_seq_autor_destino_p;

			update	procedimento_paciente
			set	nr_seq_proc_autor	= nr_seq_proc_destino_w
			where	nr_seq_proc_autor	= nr_seq_proc_ant_w;

			delete	from	procedimento_autorizado
			where	nr_sequencia	= nr_seq_proc_ant_w;

		end if;
	end loop;
	close c01;

	open c02;
	loop
	fetch c02 into
		nr_seq_mat_ant_w,
		cd_material_w,
		qt_mat_autor_origem_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		select	max(nr_sequencia)
		into STRICT	nr_seq_mat_destino_w
		from 	material_autorizado
		where	nr_sequencia_autor	= nr_seq_autor_destino_p
		and	cd_material		= cd_material_w;

		if (coalesce(nr_seq_mat_destino_w::text, '') = '') then

			select	nextval('material_autorizado_seq')
			into STRICT	nr_seq_mat_novo_w
			;

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
				vl_cotado,
				qt_dose_quimio)
			SELECT	nr_seq_mat_novo_w,
				nr_seq_autor_destino_p,
				nr_atendimento,
				nr_seq_autorizacao_w,
				cd_material,
				qt_solicitada,
				qt_autorizada,
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
				vl_cotado,
				qt_dose_quimio
			from	material_autorizado
			where	nr_sequencia 	= nr_seq_mat_ant_w;

			update	material_atend_paciente
			set	nr_seq_mat_autor	= nr_seq_mat_novo_w
			where	nr_seq_mat_autor	= nr_seq_mat_ant_w;

			delete	from material_autorizado
			where	nr_sequencia	= nr_seq_mat_ant_w;
		else

			update	material_autorizado
			set	qt_solicitada		= qt_solicitada + qt_mat_autor_origem_w,
				nm_usuario		= nm_usuario_p
			where	nr_sequencia		= nr_seq_mat_destino_w
			and	nr_sequencia_autor	= nr_seq_autor_destino_p;

			update	material_atend_paciente
			set	nr_seq_mat_autor	= nr_seq_mat_destino_w
			where	nr_seq_mat_autor	= nr_seq_mat_ant_w;

			delete	from material_autorizado
			where	nr_sequencia	= nr_seq_mat_ant_w;

		end if;

	end loop;
	close c02;

	select 	coalesce(count(*),0)
	into STRICT 	qt_proc_autor_w
	from 	procedimento_autorizado
	where 	nr_sequencia_autor	= nr_seq_autor_origem_p;

	select 	coalesce(count(*),0)
	into STRICT 	qt_mat_autor_w
	from 	material_autorizado
	where 	nr_sequencia_autor	= nr_seq_autor_origem_p;

	CALL gerar_historico_autorizacao(nr_seq_autor_destino_p,
					nr_seq_autorizacao_w,
					nr_atendimento_w,
					wheb_mensagem_pck.get_texto(300686,'NR_SEQ_AUTOR_ORIGEM_P='||nr_seq_autor_origem_p||';DS_TIPO_AUTOR_ORIGEM_W='||ds_tipo_autor_origem_w),					
					nm_usuario_p);

	if (qt_proc_autor_w = 0) and (qt_mat_autor_w = 0) and (coalesce(ie_exclui_autor_antiga_w,'N') = 'S')then

		update	autorizacao_convenio_hist
		set	nr_seq_autor_origem	= nr_sequencia_autor,
			nr_sequencia_autor	= nr_seq_autor_destino_p
		where	nr_sequencia_autor	= nr_seq_autor_origem_p;

		delete 	from autor_convenio_evento
		where	nr_sequencia_autor 	= nr_seq_autor_origem_p;
		
		update	autorizacao_convenio
		set	nr_seq_autor_desdob	 = NULL
		where	nr_seq_autor_desdob	= nr_seq_autor_origem_p;

		delete 	from autorizacao_convenio
		where	nr_sequencia		= nr_seq_autor_origem_p;

	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agrupar_autorizacao_convenio (nr_seq_autor_origem_p bigint, nr_seq_autor_destino_p bigint, nm_usuario_p text) FROM PUBLIC;

