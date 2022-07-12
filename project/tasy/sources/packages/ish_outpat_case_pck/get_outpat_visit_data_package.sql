-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_outpat_case_pck.get_outpat_visit_data ( nr_seq_fila_p bigint) RETURNS SETOF T_OUTPAT_VISIT_DATA AS $body$
DECLARE

		
r_outpat_visit_data_w		r_outpat_visit_data;

nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;

nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_empresa_w			empresa.cd_empresa%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;

nr_seq_atepacu_w		atend_paciente_unidade.nr_seq_interno%type;
nr_seq_classif_w		pessoa_classif.nr_sequencia%type;
cd_especialidade_w		atendimento_troca_medico.cd_especialidade%type;
cd_medico_dest_w		atendimento_alta.cd_medico_dest%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
cd_setor_externo_w		setor_atendimento.cd_setor_externo%type;
nm_leito_integracao_w		unidade_atendimento.nm_leito_integracao%type;
nr_asv_team_w			atend_paciente_unidade_inf.nr_asv_team%type;
cd_cgc_indicacao_w		atendimento_paciente.cd_cgc_indicacao%type;

dt_episodio_w			timestamp;
dt_entrada_w			timestamp;
dt_ocorrencia_w			timestamp;
dt_entrada_saida_unidade_w	timestamp;
movemnttype_w			varchar(255);
nm_localidade_w			varchar(255);
dt_geral_w			varchar(255);
famphys_medic_w			bigint;
cd_medico_resp_w		varchar(255);
famrefphys_medic_w		bigint;
nr_seq_posicao_w		posicao_sap.nr_sequencia%type;
nr_seq_posicao_return_w	posicao_sap.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_episodio,
		nr_seq_tipo_episodio,
		nr_seq_subtipo_episodio,
		cd_pessoa_fisica,
		ie_status,
		dt_episodio,
		dt_fim_episodio,
		coalesce(dt_atualizacao_nrec, clock_timestamp()) dt_atualizacao_nrec,
		coalesce(nm_usuario_nrec, nm_usuario) nm_usuario_nrec,
		substr(ds_observacao,1,30) ds_observacao
	from	episodio_paciente
	where	nr_sequencia in (	SELECT	b.nr_seq_episodio
					from	atendimento_paciente b
					where	b.nr_atendimento = nr_seq_documento_w);

c01_w	c01%rowtype;

c02 CURSOR FOR
	SELECT	cd_estabelecimento,
		ie_tipo_atendimento,
		nr_dias_prev_alta,
		cd_cgc_indicacao,
		nr_seq_tipo_acidente,
		dt_ocorrencia,
		cd_municipio_ocorrencia,
		nr_seq_forma_chegada,		
		cd_medico_resp,
		dt_ultima_menstruacao,
		qt_ig_semana,
		nr_seq_queixa,
		dt_entrada,
		nm_usuario_atend,
		ds_observacao,
		nr_seq_tipo_admissao_fat,
		dt_chegada_paciente,
		nr_seq_episodio,
		cd_procedencia,
		ie_inform_incompletas
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;

c02_w	c02%rowtype;

c03 CURSOR FOR
	SELECT	nr_seq_interno,
		nr_seq_motivo_int,
		dt_entrada_unidade,
		dt_saida_unidade,
		cd_tipo_acomodacao,
		cd_setor_atendimento,
		cd_unidade_basica,
		cd_unidade_compl,
		cd_departamento,
		substr(Obter_Dados_AtePacu(a.nr_seq_interno, 3),1,10) nr_seq_classif_esp
	from	atend_paciente_unidade a
	where	nr_seq_interno = nr_seq_atepacu_w;

c03_w	c03%rowtype;

c04 CURSOR FOR
	SELECT	qt_peso,
		qt_altura_cm,
		b.cd_medico,
		b.nr_seq_tipo_medico
	FROM pessoa_fisica a
LEFT OUTER JOIN pf_medico_externo b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica)
WHERE (coalesce(b.dt_fim_vigencia::text, '') = '' or (trunc(b.dt_fim_vigencia) > trunc(clock_timestamp()))) and a.cd_pessoa_fisica = c01_w.cd_pessoa_fisica;

c04_w	c04%rowtype;

c05 CURSOR FOR
SELECT	a.*
from	atendimento_paciente_inf a
where	a.nr_atendimento in (select	x.nr_atendimento
	from	atendimento_paciente x
	where	x.nr_seq_episodio = c01_w.nr_sequencia)  LIMIT 1;
	
c05_w	c05%rowtype;


BEGIN
select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
	ie_conversao_w,	
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);
reg_integracao_w.nm_tabela 			:= 'EPISODIO_PACIENTE';
reg_integracao_w.nm_elemento			:= 'OutpatVisitData';

open c01;
loop
fetch c01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	/*case*/

	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_TIPO_EPISODIO','casetypeext', 'N', c01_w.nr_seq_tipo_episodio, 'S', r_outpat_visit_data_w.casetypeext);
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_SUBTIPO_EPISODIO','casecategory', 'N', c01_w.nr_seq_subtipo_episodio, 'S', r_outpat_visit_data_w.casecategory);
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','extcaseid', 'N', c01_w.nr_sequencia, 'N', r_outpat_visit_data_w.extcaseid);
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_OBSERVACAO','casecomment', 'N', c01_w.ds_observacao, 'N', r_outpat_visit_data_w.casecomment);
	nr_atendimento_w := nr_seq_documento_w;
	
	open c02;
	loop
	fetch c02 into	
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin	
		reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';		
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_ENTRADA','startdate', 'N', c02_w.dt_entrada, 'N', dt_entrada_w);
		r_outpat_visit_data_w.startdate		:= to_char(dt_entrada_w,'YYYY-MM-DD');
		r_outpat_visit_data_w.startdatex	:= null;
		
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_ENTRADA','movemntdate', 'N', c02_w.dt_entrada, 'N', dt_entrada_w);
		r_outpat_visit_data_w.movemntdate	:= to_char(dt_entrada_w,'YYYY-MM-DD');
		r_outpat_visit_data_w.movemnttime	:= to_char(dt_entrada_w,'HH24:MI:SS');
		
		begin
		select	min(dt_entrada)
		into STRICT	dt_episodio_w
		from	atendimento_paciente
		where	nr_seq_episodio	= c02_w.nr_seq_episodio
		and	coalesce(dt_cancelamento::text, '') = ''
		and	nr_atendimento <> nr_atendimento_w;
		
		if (coalesce(dt_episodio_w::text, '') = '') or (dt_episodio_w > dt_entrada_w) then
			r_outpat_visit_data_w.startdatex	:= 'X';
		end if;
		exception
		when others then
			r_outpat_visit_data_w.startdatex	:= null;
		end;
		
		r_outpat_visit_data_w.enddate		:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','creationdate', 'N', c02_w.dt_entrada, 'N', dt_entrada_w);
		r_outpat_visit_data_w.creationdate	:= to_char(dt_entrada_w,'YYYY-MM-DD');
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','creationtime', 'N', c02_w.dt_entrada, 'N', dt_entrada_w);
		r_outpat_visit_data_w.creationtime	:= to_char(dt_entrada_w,'HH24:MI:SS');
		intpd_processar_atrib_envio(reg_integracao_w, 'NM_USUARIO_NREC', 'creationuser', 'N', ish_param_pck.get_nm_usuario, 'N', r_outpat_visit_data_w.creationuser);
		
		if (c02_w.ie_tipo_atendimento = 3) then
			r_outpat_visit_data_w.emergadm	:= 'X';
			r_outpat_visit_data_w.emergcase	:= 'X';
		end if;
		
		/*intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_TIPO_ADMISSAO_FAT', 'movemnttype', 'N', c02_w.nr_seq_tipo_admissao_fat, 'S', movemnttype_w);
		r_outpat_visit_data_w.movemnttype	:=	substr(movemnttype_w, instr(movemnttype_w,ds_separador_w)+1, 255);*/
		
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_TIPO_ADMISSAO_FAT', 'movemnttype', 'N', c02_w.nr_seq_tipo_admissao_fat, 'S', movemnttype_w);		
		if (ish_param_pck.get_conv_tipo_adm_fat = 'CTMCMT') then
			r_outpat_visit_data_w.movemnttype	:=	substr(obter_valor_campo_separador(movemnttype_w, 3, current_setting('ish_outpat_case_pck.ds_separador_w')::varchar(10)), 1, 255);
		else
			r_outpat_visit_data_w.movemnttype	:=	substr(obter_valor_campo_separador(movemnttype_w, 2, current_setting('ish_outpat_case_pck.ds_separador_w')::varchar(10)), 1, 255);
		end if;

		intpd_processar_atrib_envio(reg_integracao_w, 'CD_PROCEDENCIA', 'refpsttrttype', 'N', null, 'N', r_outpat_visit_data_w.refpsttrttype);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_DIAS_PREV_ALTA','lengthofstay', 'N', c02_w.nr_dias_prev_alta, 'N', r_outpat_visit_data_w.lengthofstay);

		cd_cgc_indicacao_w := c02_w.cd_cgc_indicacao;

		if (coalesce(cd_cgc_indicacao_w, 'NULL') = 'NULL') then
			begin
				select	api.cd_cgc_indicacao
				into STRICT	cd_cgc_indicacao_w
				from	atendimento_paciente_inf api
				where	api.nr_sequencia = (SELECT	max(aux.nr_sequencia)
											from	atendimento_paciente_inf aux
											where	aux.nr_atendimento = nr_atendimento_w);
			exception when no_data_found then
				cd_cgc_indicacao_w := null;
			end;
		end if;

		if (coalesce(cd_cgc_indicacao_w, 'NULL') <> 'NULL') then
			intpd_processar_atrib_envio(reg_integracao_w, 'CD_CGC_INDICACAO','refhospital', 'N', lpad(somente_numero(cd_cgc_indicacao_w), 10, 0), 'N', r_outpat_visit_data_w.refhospital);
		else
			intpd_processar_atrib_envio(reg_integracao_w, 'CD_CGC_INDICACAO','refhospital', 'N', null, 'N', r_outpat_visit_data_w.refhospital);
		end if;

		select	max(a.ds_valor)
		into STRICT	cd_medico_resp_w
		from	intpd_eventos_valores a,
			intpd_fila_transmissao b
		where	a.nm_elemento	= 'ATENDIMENTO_PACIENTE'
		and	a.nm_atributo	= 'CD_MEDICO_RESP'
		and	a.ie_situacao	= 'A'
		and	a.nr_seq_evento_sistema = b.nr_seq_evento_sistema
		and	b.nr_sequencia = nr_seq_fila_p;
		
		if (c02_w.cd_medico_resp = cd_medico_resp_w) then
			r_outpat_visit_data_w.attphys	:= null;
		else	
			intpd_processar_atrib_envio(reg_integracao_w, 'CD_MEDICO_RESP', 'attphys', 'N', c02_w.cd_medico_resp, 'ISHMED', r_outpat_visit_data_w.attphys);
		end if;

    if (coalesce(c02_w.ie_inform_incompletas, 'N') = 'S') then
			intpd_processar_atrib_envio(reg_integracao_w, 'IE_INFORM_INCOMPLETAS', 'quickadm', 'N', 'X', 'N', r_outpat_visit_data_w.quickadm);
		else
			intpd_processar_atrib_envio(reg_integracao_w, 'IE_INFORM_INCOMPLETAS', 'quickadm', 'N', '', 'N', r_outpat_visit_data_w.quickadm);
		end if;

		exit;
		end;
	end loop;
	close c02;
	
	open C05;
	loop
	fetch C05 into
		c05_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		reg_integracao_w.nm_tabela	:= 'ATENDIMENTO_PACIENTE_INF';
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_TIPO_ACIDENTE', 'accident', 'N', c05_w.nr_seq_tipo_acidente, 'S', r_outpat_visit_data_w.accident);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_FORMA_CHEGADA', 'arrivalmode', 'N', c05_w.nr_seq_forma_chegada, 'S', r_outpat_visit_data_w.arrivalmode);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_ACIDENTE', 'accidentno', 'N', c05_w.nr_acidente, 'N', r_outpat_visit_data_w.accidentno);
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_MEDICO','refphys2', 'N', c05_w.cd_medico, 'ISHMED', r_outpat_visit_data_w.refphys2);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_RQE', 'refphyslanr', 'N', c05_w.nr_rqe, 'N', r_outpat_visit_data_w.refphyslanr);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_BSNR', 'refphysbsnr', 'N', c05_w.nr_bsnr, 'N', r_outpat_visit_data_w.refphysbsnr);		
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_ACIDENTE', 'accidentloc', 'N', c05_w.ds_acidente, 'N', r_outpat_visit_data_w.accidentloc);
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_OCORRENCIA', 'accidentdate', 'N', c05_w.dt_ocorrencia, 'N', dt_geral_w);
		r_outpat_visit_data_w.accidentdate	:= to_char(to_date(dt_geral_w),'YYYY-MM-DD');
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_OCORRENCIA', 'accidenttime', 'N', c05_w.dt_ocorrencia, 'N', dt_geral_w);
		r_outpat_visit_data_w.accidenttime	:= to_char(to_date(dt_geral_w),'HH24:MI:SS');
		dt_geral_w	:= null;
		
		if (c05_w.dt_validade IS NOT NULL AND c05_w.dt_validade::text <> '') then
			intpd_processar_atrib_envio(reg_integracao_w, 'DT_INICIO_VALIDADE', 'startdate', 'N', c05_w.dt_inicio_validade, 'N', dt_geral_w);			
			r_outpat_visit_data_w.startdate		:= to_char(to_date(dt_geral_w),'YYYY-MM-DD');
			r_outpat_visit_data_w.startdatex	:= 'X';
			dt_geral_w	:= null;			
			intpd_processar_atrib_envio(reg_integracao_w, 'DT_VALIDADE', 'enddate', 'N', c05_w.dt_validade, 'N', dt_geral_w);			
			r_outpat_visit_data_w.enddate		:= to_char(to_date(dt_geral_w),'YYYY-MM-DD');
			r_outpat_visit_data_w.enddatex		:= 'X';
			dt_geral_w	:= null;
		end if;
	end loop;
	close C05;
	
	/*'P = Primeira Unidade'*/

	nr_seq_atepacu_w := obter_atepacu_paciente(nr_atendimento_w,'P');

	open c03;
	loop
	fetch c03 into	
		c03_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_CLASSIF_ESP', 'treatmcategory', 'N', c03_w.nr_seq_classif_esp, 'S', r_outpat_visit_data_w.treatmcategory);
		
		reg_integracao_w.nm_tabela 	:= 'ATEND_PACIENTE_UNIDADE';		
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_MOTIVO_INT','movemntreas1', 'N', c03_w.nr_seq_motivo_int, 'S', r_outpat_visit_data_w.movemntreas1);
		
		begin
		select	cd_setor_externo
		into STRICT	cd_setor_externo_w
		from	setor_atendimento
		where	cd_setor_atendimento = c03_w.cd_setor_atendimento
		and	(cd_setor_externo IS NOT NULL AND cd_setor_externo::text <> '')  LIMIT 1;
		
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_SETOR_ATENDIMENTO', 'nurstreatou', 'N', cd_setor_externo_w, 'N', r_outpat_visit_data_w.nurstreatou);
		exception
		when others then
			intpd_processar_atrib_envio(reg_integracao_w, 'CD_SETOR_ATENDIMENTO', 'nurstreatou', 'N', c03_w.cd_setor_atendimento, 'S', r_outpat_visit_data_w.nurstreatou);
		end;		
		
		reg_integracao_w.nm_tabela	:= 'UNIDADE_ATENDIMENTO';
		
		--Se a unidade for uma unidade virtual no Tasy, nao e necessario enviar para o ISH.
		if (ish_pat_case_pck.OBTER_SE_SEM_ACOMOD(c03_w.cd_setor_atendimento,c03_w.cd_unidade_basica, c03_w.cd_unidade_compl) = 'N') then
		
			begin
			select	nm_leito_integracao
			into STRICT	nm_leito_integracao_w
			from	unidade_atendimento
			where	cd_setor_atendimento = c03_w.cd_setor_atendimento
			and	cd_unidade_basica = c03_w.cd_unidade_basica
			and	cd_unidade_compl = c03_w.cd_unidade_compl;
			
			if (position(current_setting('ish_outpat_case_pck.ds_separador_w')::varchar(10) in nm_leito_integracao_w) > 0) then
				intpd_processar_atrib_envio(reg_integracao_w, 'NM_LEITO_INTEGRACAO', 'bed', 'N', obter_valor_campo_separador(nm_leito_integracao_w,2,current_setting('ish_outpat_case_pck.ds_separador_w')::varchar(10)), 'N', r_outpat_visit_data_w.bed);
			else			
				intpd_processar_atrib_envio(reg_integracao_w, 'NM_LEITO_INTEGRACAO', 'bed', 'N', nm_leito_integracao_w, 'N', r_outpat_visit_data_w.bed);
			end if;
			exception
			when others then
				begin
				reg_integracao_w.nm_tabela	:= 'ATEND_PACIENTE_UNIDADE';
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_UNIDADE_BASICA', 'room', 'N', c03_w.cd_unidade_basica, 'S', r_outpat_visit_data_w.room);
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_UNIDADE_COMPL', 'bed', 'N', c03_w.cd_unidade_compl, 'S', r_outpat_visit_data_w.bed);
				end;
			end;		
			
			if (position(current_setting('ish_outpat_case_pck.ds_separador_w')::varchar(10) in nm_leito_integracao_w) > 0) then
				r_outpat_visit_data_w.room	:=	obter_valor_campo_separador(nm_leito_integracao_w,1,current_setting('ish_outpat_case_pck.ds_separador_w')::varchar(10));
			elsif (somente_numero(r_outpat_visit_data_w.bed) > 0) then
				r_outpat_visit_data_w.room	:=	ish_pat_case_pck.get_room_code(r_outpat_visit_data_w.bed);			
			end if;
		end if;
		
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_SAIDA_UNIDADE','movemntenddate', 'N', c03_w.dt_saida_unidade, 'N', dt_entrada_saida_unidade_w);
		r_outpat_visit_data_w.movemntenddate	:= to_char(dt_entrada_saida_unidade_w,'YYYY-MM-DD');
		r_outpat_visit_data_w.movemntendtime	:= to_char(dt_entrada_saida_unidade_w,'HH24:MI:SS');
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO','extmovementid', 'N', c03_w.nr_seq_interno, 'N', r_outpat_visit_data_w.extmovementid);		
		reg_integracao_w.nm_tabela 		:= 'ATEND_PACIENTE_UNIDADE';
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_DEPARTAMENTO', 'department', 'N', c03_w.cd_departamento, 'S', r_outpat_visit_data_w.department);
		
		select	max(nr_asv_team)
		into STRICT	nr_asv_team_w
		from	atend_paciente_unidade_inf
		where	nr_seq_atend_pac_unidade = nr_seq_atepacu_w;

		r_outpat_visit_data_w.attphysteamno	:=	lpad(nr_asv_team_w,9,0);
		exit;
		end;
	end loop;
	close c03;

	if	((trunc(c03_w.dt_entrada_unidade) > trunc(clock_timestamp())) and (coalesce(c02_w.dt_chegada_paciente::text, '') = '')) or (obter_se_atendimento_futuro(nr_atendimento_w) = 'S') then
		r_outpat_visit_data_w.ExtVisitStat	:=	'P';
	else	
		r_outpat_visit_data_w.ExtVisitStat	:=	null;
	end if;	

	reg_integracao_w.nm_tabela	:= 'ATENDIMENTO_PACIENTE_AUX';

	begin
		select	atendimento_paciente_aux.nr_seq_posicao
		into STRICT	nr_seq_posicao_w
		from	atendimento_paciente_aux
		where	atendimento_paciente_aux.nr_atendimento = nr_atendimento_w;
	exception
	when others then
		nr_seq_posicao_w := null;
	end;

	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_POSICAO', 'admittdept', 'N', nr_seq_posicao_w, 'N', nr_seq_posicao_return_w);

	if (nr_seq_posicao_return_w IS NOT NULL AND nr_seq_posicao_return_w::text <> '') then
		begin
			select	posicao_sap.cd_external_code
			into STRICT	r_outpat_visit_data_w.admittdept
			from	posicao_sap
			where	posicao_sap.nr_sequencia = nr_seq_posicao_return_w;
		exception
		when others then
			r_outpat_visit_data_w.admittdept := null;
		end;
	end if;

	select	max(cd_especialidade)
	into STRICT	cd_especialidade_w
	from	atendimento_troca_medico
	where	nr_atendimento = nr_atendimento_w;

	reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_TROCA_MEDICO';
	--intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESPECIALIDADE','specialty', 'N', cd_especialidade_w, 'S', r_outpat_visit_data_w.specialty);
	r_outpat_visit_data_w.specialty		:= null;
	r_outpat_visit_data_w.specialtyvisit	:= null;
	r_outpat_visit_data_w.respirationx		:= null;
	
	select	max(a.cd_medico_dest)
	into STRICT	cd_medico_dest_w
	from	atendimento_alta a, parametro_medico p
	where	nr_atendimento = nr_atendimento_w
	and     p.cd_estabelecimento = obter_estabelecimento_ativo
	and 	((a.ie_tipo_orientacao <> 'P')
	or (coalesce(p.ie_liberar_desfecho,'N')  = 'N')
	or  	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and (coalesce(a.dt_inativacao::text, '') = '')));
	
	reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_ALTA';
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_MEDICO_DEST','postdisphys', 'N', cd_medico_dest_w, 'ISHMED', r_outpat_visit_data_w.postdisphys);
	
	open c04;
	loop
	fetch c04 into
		c04_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
		begin
		reg_integracao_w.nm_tabela 	:= 'PESSOA_FISICA';
		intpd_processar_atrib_envio(reg_integracao_w, 'QT_PESO','patweight', 'N', c04_w.qt_peso, 'N', r_outpat_visit_data_w.patweight);
		--r_outpat_visit_data_w.weightunit	:= 'kg';
		r_outpat_visit_data_w.weightunitiso	:= 'KGM'; --OS 1956899
		intpd_processar_atrib_envio(reg_integracao_w, 'QT_ALTURA_CM','patheight', 'N', c04_w.qt_altura_cm, 'N', r_outpat_visit_data_w.patheight);
		--r_outpat_visit_data_w.heightunit	:= 'cm';
		r_outpat_visit_data_w.heightunitiso	:= 'CMT'; --OS 1956899
		
		reg_integracao_w.nm_tabela 	:= 'PF_MEDICO_EXTERNO';
		famphys_medic_w := somente_numero(intpd_conv('TIPO_MEDICO_EXTERNO', 'NR_SEQUENCIA', 'FAMPHYS', nr_seq_regra_w, ie_conversao_w, 'I'));
		famrefphys_medic_w := somente_numero(intpd_conv('TIPO_MEDICO_EXTERNO', 'NR_SEQUENCIA', 'FAMREFPHYS', nr_seq_regra_w, ie_conversao_w, 'I'));
		
		if (c04_w.nr_seq_tipo_medico = famphys_medic_w) or (c04_w.nr_seq_tipo_medico = famrefphys_medic_w) then
			intpd_processar_atrib_envio(reg_integracao_w, 'CD_MEDICO', 'famphys', 'N', c04_w.cd_medico, 'ISHMED', r_outpat_visit_data_w.famphys);
			exit;
		end if;
		end;
	end loop;
	close c04;
	
	begin
	select  'X'
	into STRICT	r_outpat_visit_data_w.pirconsent
	from  	atendimento_paciente a,
		atend_categoria_convenio b,
		convenio c
	where	a.nr_atendimento	= b.nr_atendimento
	and	b.cd_convenio		= c.cd_convenio
	/*and	c.ie_tipo_convenio	= 2	--SO 2157727 We should not have the restriction for public or private. When checked, we should send it*/

	and	a.nr_seq_episodio	= c01_w.nr_sequencia
	and	b.ie_autoriza_envio_convenio = 'S'  LIMIT 1;
	exception
	when others then
		r_outpat_visit_data_w.pirconsent	:= null;
	end;
	r_outpat_visit_data_w.pirconsentx	:= 'X';
	
	RETURN NEXT r_outpat_visit_data_w;
	
	end;
end loop;
close c01;

CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_outpat_case_pck.get_outpat_visit_data ( nr_seq_fila_p bigint) FROM PUBLIC;
