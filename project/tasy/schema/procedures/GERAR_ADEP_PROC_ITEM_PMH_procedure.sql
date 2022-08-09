-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_adep_proc_item_pmh ( nr_processo_p bigint, nr_seq_area_preparo_p bigint, cd_material_p bigint, cd_material_barras_p bigint, qt_material_p bigint, cd_unidade_medida_p text, nr_seq_lote_fornec_p bigint, ie_conta_paciente_p text, ie_prescricao_p text, nm_usuario_p text, nr_seq_horario_p bigint, ie_baixa_estoque_p text, nr_seq_item_nreq_p bigint, nr_seq_prod_p bigint default null) AS $body$
DECLARE

				
nr_seq_api_w				bigint;
ds_exception_w				varchar(2000);
cd_estabelecimento_w		smallint;
cd_setor_atendimento_w		integer;
cd_local_estoque_w			smallint;
ie_lanca_conta_w			varchar(1);
ie_baixa_estoque_w			varchar(1);
nr_seq_regra_w				bigint;
nr_seq_frac_w				bigint;
cd_motivo_baixa_w			smallint;
ie_nao_requisitado_w		varchar(1);
ie_nao_req_est_paciente_w	varchar(15);
nr_seq_lote_w				bigint;
nr_seq_pmh_w				prescr_mat_hor.nr_sequencia%type;
nr_lote_producao_w			lp_individual.nr_lote_producao%type;
nr_rowid_w					oid;

C01 CURSOR FOR
SELECT	ie_lanca_conta,
	ie_baixa_estoque,
	nr_sequencia
from	regra_disp_gedipa
where	cd_estabelecimento					= cd_estabelecimento_w
and	coalesce(cd_setor_atendimento,cd_setor_atendimento_w)	= cd_setor_atendimento_w
and	coalesce(cd_local_estoque,cd_local_estoque_w)		= cd_local_estoque_w
and	((coalesce(ie_padronizado,'A') = 'A') or
	 ((coalesce(ie_padronizado,'A') = 'S') and (obter_se_material_padronizado(cd_estabelecimento_w,cd_material_barras_p)) = 'S') or
	 ((coalesce(ie_padronizado,'A') = 'N') and (obter_se_material_padronizado(cd_estabelecimento_w,cd_material_barras_p)) = 'N'))
and	clock_timestamp() between dt_inicio_validade and coalesce(dt_fim_validade,clock_timestamp())
order by
	coalesce(cd_setor_atendimento,0),
	coalesce(cd_local_estoque,0),
	dt_inicio_validade;
	

BEGIN

if (nr_processo_p IS NOT NULL AND nr_processo_p::text <> '') and (cd_material_barras_p IS NOT NULL AND cd_material_barras_p::text <> '') and (qt_material_p IS NOT NULL AND qt_material_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin	
	ie_nao_req_est_paciente_w := obter_param_usuario(3112, 51, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_nao_req_est_paciente_w);

	if (coalesce(ie_prescricao_p,'S') = 'S') then
		ie_nao_requisitado_w	:= 'N';
	else
		ie_nao_requisitado_w	:= 'S';
	end if;

	select	obter_estab_atend(nr_atendimento),
			cd_setor_atendimento,
			cd_local_estoque
	into STRICT	cd_estabelecimento_w,
			cd_setor_atendimento_w,
			cd_local_estoque_w
	from	adep_processo
	where	nr_sequencia = nr_processo_p;

	open c01;
	loop
	fetch c01 into	ie_lanca_conta_w,
			ie_baixa_estoque_w,
			nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin		
		ie_lanca_conta_w		:= ie_lanca_conta_w;
		ie_baixa_estoque_w	:= ie_baixa_estoque_w;
		nr_seq_regra_w		:= nr_seq_regra_w;		
		end;
	end loop;
	close c01;
	
	if (coalesce(nr_seq_horario_p,0) > 0) then
		nr_seq_pmh_w	:= nr_seq_horario_p;
	elsif (coalesce(nr_processo_p,0) > 0) then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_pmh_w
		from	prescr_mat_hor
		where	nr_seq_processo				= nr_processo_p
		and		cd_material					= cd_material_p;		
	end if;

	if (coalesce(nr_seq_pmh_w,0) > 0) then
		select	max(nr_seq_etiqueta),
				max(cd_motivo_baixa),
				max(nr_seq_lote)
		into STRICT	nr_seq_frac_w,
				cd_motivo_baixa_w,
				nr_seq_lote_w
		from	prescr_mat_hor
		where	nr_sequencia	= nr_seq_pmh_w
		and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
		
		if (coalesce(cd_motivo_baixa_w,0) > 0) then
			select	coalesce(max(ie_atualiza_estoque),'S')
			into STRICT	ie_baixa_estoque_w
			from	tipo_baixa_prescricao
			where	cd_tipo_baixa		= cd_motivo_baixa_w;		
		end if;
	end if;
		
	if (ie_nao_req_est_paciente_w = 'SL') then
		if (coalesce(nr_seq_lote_w::text, '') = '') then
			ie_nao_requisitado_w := 'S';
		else
			ie_nao_requisitado_w := 'N';
		end if;
	end if;
			
	if (ie_baixa_estoque_p = 'N') then
		ie_baixa_estoque_w := 'N';
	end if;
	
	if (nr_seq_prod_p IS NOT NULL AND nr_seq_prod_p::text <> '') then
		begin
		
		select max(nr_lote_producao)
		into STRICT	nr_lote_producao_w
		from	lp_individual
		where	nr_sequencia = nr_seq_prod_p;
		
		end;
	end if;
	
begin	
	select	max(a.rowid)
	into STRICT	nr_rowid_w
	from	adep_processo_item	a
	where	a.nr_seq_processo = nr_processo_p
	and (a.nr_seq_horario = nr_seq_horario_p or coalesce(nr_seq_horario_p::text, '') = '')
	and (a.nr_seq_lote_fornec = nr_seq_lote_fornec_p or coalesce(nr_seq_lote_fornec_p,0) = 0)
	and		a.cd_material = cd_material_p
	and		a.ie_nao_requisitado = 'N'
	and		ie_nao_requisitado_w = 'N';

	if (nr_rowid_w IS NOT NULL AND nr_rowid_w::text <> '') then
		update	adep_processo_item	a
		set		a.qt_material	= a.qt_material + qt_material_p,
				a.qt_conta		= a.qt_conta + qt_material_p,
				a.qt_estoque	= a.qt_estoque + qt_material_p
		where	a.rowid			= nr_rowid_w;
	else
		select	nextval('adep_processo_item_seq')
		into STRICT	nr_seq_api_w
		;	
		
		insert into adep_processo_item(
			nr_sequencia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			nr_seq_processo,
			cd_material,
			qt_material,
			cd_unidade_medida,
			nr_seq_lote_fornec,
			qt_conta,
			cd_unidade_medida_conta,
			qt_estoque,
			cd_unidade_medida_estoque,
			ie_lanca_conta,
			ie_baixa_estoque,
			cd_material_original,
			ie_conta_paciente,
			nr_seq_area_prep,
			nr_seq_horario,
			nr_seq_frac,
			ie_nao_requisitado,
			nr_seq_item_nreq,
			nr_lote_producao)
		values (
			nr_seq_api_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_processo_p,
			cd_material_barras_p,
			qt_material_p,
			cd_unidade_medida_p,
			CASE WHEN nr_seq_lote_fornec_p=0 THEN  null  ELSE nr_seq_lote_fornec_p END ,
			qt_material_p,
			cd_unidade_medida_p,
			qt_material_p,
			cd_unidade_medida_p,
			CASE WHEN ie_conta_paciente_p='N' THEN  ie_conta_paciente_p  ELSE ie_lanca_conta_w END ,
			ie_baixa_estoque_w,
			cd_material_p,
			'N',
			CASE WHEN nr_seq_area_preparo_p=0 THEN  null  ELSE nr_seq_area_preparo_p END ,
			CASE WHEN nr_seq_horario_p=0 THEN  null  ELSE nr_seq_horario_p END ,
			nr_seq_frac_w,
			ie_nao_requisitado_w,
			nr_seq_item_nreq_p,
			nr_lote_producao_w);		
	end if;
exception when others then
	ds_exception_w := substr(to_char(sqlerrm),1,2000);
	
	CALL gravar_log_tasy(55, substr('nr_processo_p='||nr_processo_p||
	chr(10)||'nr_seq_area_preparo_p='||nr_seq_area_preparo_p||
	chr(10)||'cd_material_p='||cd_material_p||
	chr(10)||'cd_material_barras_p='||cd_material_barras_p||
	chr(10)||'qt_material_p='||qt_material_p||
	chr(10)||'cd_unidade_medida_p='||cd_unidade_medida_p||
	chr(10)||'nr_seq_lote_fornec_p='||nr_seq_lote_fornec_p||
	chr(10)||'ie_conta_paciente_p='||ie_conta_paciente_p||
	chr(10)||'ie_prescricao_p='||ie_prescricao_p||
	chr(10)||'nm_usuario_p='||nm_usuario_p||
	chr(10)||'nr_seq_horario_p='||nr_seq_horario_p||
	chr(10)||'ie_baixa_estoque_p='||ie_baixa_estoque_p||
	chr(10)||'nr_seq_item_nreq_p='||nr_seq_item_nreq_p||
	chr(10)||'nr_seq_prod_p='||nr_seq_prod_p||
	chr(10)||'ds_exception_w='||ds_exception_w||
	chr(10)||'ds_stack='||dbms_utility.format_call_stack,1,2000),
	nm_usuario_p);
end;		
	end;	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_adep_proc_item_pmh ( nr_processo_p bigint, nr_seq_area_preparo_p bigint, cd_material_p bigint, cd_material_barras_p bigint, qt_material_p bigint, cd_unidade_medida_p text, nr_seq_lote_fornec_p bigint, ie_conta_paciente_p text, ie_prescricao_p text, nm_usuario_p text, nr_seq_horario_p bigint, ie_baixa_estoque_p text, nr_seq_item_nreq_p bigint, nr_seq_prod_p bigint default null) FROM PUBLIC;
