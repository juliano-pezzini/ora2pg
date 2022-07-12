-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_pat_case_pck.get_inpat_discharge_data ( nr_seq_fila_p bigint) RETURNS SETOF T_INPAT_DISCHARGE_DATA AS $body$
DECLARE


r_inpat_discharge_data_w		r_inpat_discharge_data;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
ie_evento_w			intpd_fila_transmissao.ie_evento%type;

cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_empresa_w			empresa.cd_empresa%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_submotivo_alta_w		atendimento_paciente.nr_submotivo_alta%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
dt_geral_w			varchar(255);
cd_motivo_alta_w 		varchar(100);
atendimento_paciente_w		atendimento_paciente%rowtype;
ie_tipo_atendimento_w		atendimento_paciente_w.ie_tipo_atendimento%type;
nr_sequencia_w			episodio_paciente.nr_episodio%type;
ds_observacao_w			episodio_paciente.ds_observacao%type;
dt_alta_curativo_w		cur_ferida.dt_alta_curativo%type;
cd_medico_dest_w		atendimento_alta.cd_medico_dest%type;
nm_usuario_alta_medica_w	varchar(100);
qt_peso_w			pessoa_fisica.qt_peso%type;
qt_altura_cm_w			pessoa_fisica.qt_altura_cm%type;
cd_hospital_destino_w		atendimento_transf.cd_cgc%type;
qt_peso_str_w			varchar(7);
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
nr_seq_submotivo_w		submotivo_alta.nr_seq_submotivo%type;

c01 CURSOR FOR
SELECT	nr_atendimento,
	cd_motivo_alta,
	(select	max(x.dt_saida_unidade)
	from	atend_paciente_unidade x 
	where	x.nr_atendimento = a.nr_atendimento
	and	x.nr_seq_interno = obter_atepacu_paciente(x.nr_atendimento, 'A')) dt_saida_unidade,
	obter_atepacu_paciente(a.nr_atendimento, 'A') nr_seq_interno,
	nm_usuario_alta_medica,
	cd_pessoa_fisica
from	atendimento_paciente a
where	nr_atendimento = nr_atendimento_w;

c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	*
from	atend_previsao_alta a
where	a.nr_atendimento	= nr_atendimento_w
and	a.nr_sequencia	=
	(select max(x.nr_sequencia)
	from	 atend_previsao_alta x
	where	 x.nr_atendimento	= nr_atendimento_w
	and	 x.ie_situacao	= 'A'
	and	 (x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> ''));
	
c02_w	c02%rowtype;


BEGIN
select	somente_numero(a.nr_seq_documento),
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv,
	a.ie_evento
into STRICT	nr_atendimento_w,
	ie_conversao_w,	
	nr_seq_regra_w,
	ie_evento_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);

if (ie_evento_w = '402') then --Enviar previsao de alta.
	open C02;
	loop
	fetch C02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
	
		reg_integracao_w.nm_tabela 		:= 'ATENDIMENTO_PACIENTE';
		reg_integracao_w.nm_elemento	:= 'InpatDischargeData';
		
		--intpd_processar_atrib_envio(reg_integracao_w, 'CD_MOTIVO_ALTA', 'movemnttype', 'N', 'PLANNED', 'S', r_inpat_discharge_data_w.movemnttype); --OS 1751858
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_SAIDA_UNIDADE', 'movemntdate', 'N', c02_w.DT_PREVISTO_ALTA, 'N', dt_geral_w);
		r_inpat_discharge_data_w.movemntdate	:=	to_char(to_date(dt_geral_w),'yyyy-mm-dd');
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_SAIDA_UNIDADE', 'movemnttime', 'N',  c02_w.DT_PREVISTO_ALTA, 'N', dt_geral_w);
		r_inpat_discharge_data_w.movemnttime	:=	to_char(to_date(dt_geral_w),'hh24:mi:ss');
		dt_geral_w	:= null;		
		r_inpat_discharge_data_w.statusind		:=	'P'; /*"p" plan or "blank" real*/
		
		select	*
		into STRICT	atendimento_paciente_w
		from	atendimento_paciente
		where	nr_atendimento = c02_w.nr_atendimento;
		
		intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_ATENDIMENTO', 'emergadm', 'N', atendimento_paciente_w.ie_tipo_atendimento, 'N', ie_tipo_atendimento_w);
		if (ie_tipo_atendimento_w = '3') then
			r_inpat_discharge_data_w.emergadm	:= 'X';
		end if;
		intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_ATENDIMENTO', 'emergadmx', 'S', atendimento_paciente_w.ie_tipo_atendimento, 'N', r_inpat_discharge_data_w.emergadmx);
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_ATUALIZACAO', 'creationdate', 'N', c02_w.dt_atualizacao, 'N', dt_geral_w);
		r_inpat_discharge_data_w.creationdate	:= to_char(to_date(dt_geral_w),'yyyy-mm-dd');
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_ATUALIZACAO', 'creationtime', 'N', c02_w.dt_atualizacao, 'N', dt_geral_w);
		r_inpat_discharge_data_w.creationtime	:= to_char(to_date(dt_geral_w),'hh24:mi:ss');
		intpd_processar_atrib_envio(reg_integracao_w, 'NM_USUARIO_NREC', 'creationuser', 'N', ish_param_pck.get_nm_usuario, 'N', r_inpat_discharge_data_w.creationuser);

		select	max(nr_sequencia),
			substr(max(ds_observacao),1,30)
		into STRICT	nr_sequencia_w,
			ds_observacao_w
		from	episodio_paciente
		where	nr_sequencia in (SELECT x.nr_seq_episodio from atendimento_paciente x where x.nr_atendimento = c02_w.nr_atendimento);
		
		reg_integracao_w.nm_tabela 	:= 'EPISODIO_PACIENTE';
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA', 'extcaseid', 'N', nr_sequencia_w, 'N', r_inpat_discharge_data_w.extcaseid);		
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'extmovementid', 'N', c02_w.nr_sequencia, 'N', r_inpat_discharge_data_w.extmovementid);
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_OBSERVACAO', 'casecomment', 'N', ds_observacao_w, 'N', r_inpat_discharge_data_w.casecomment);
				
		reg_integracao_w.nm_tabela 	:= 'ATEND_PREVISAO_ALTA';
		--intpd_processar_atrib_envio(reg_integracao_w, 'CD_PROFISSIONAL', 'disphys', 'N', c02_w.CD_PROFISSIONAL, 'S', r_inpat_discharge_data_w.disphys);
				
	end loop;
	close C02;	

else

	open c01;
	loop
	fetch c01 into	
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin				
		select max(nr_submotivo_alta) into STRICT nr_submotivo_alta_w from atendimento_paciente where nr_atendimento = c01_w.nr_atendimento;
		
		reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
		reg_integracao_w.nm_elemento	:= 'InpatDischargeData';
		cd_motivo_alta_w  := c01_w.cd_motivo_alta||current_setting('ish_pat_case_pck.ds_separador_w')::varchar(10);
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_MOTIVO_ALTA', 'movemnttype', 'N',
			intpd_conv('DISCHARGE_DATA', 'MOVEMNTTYPE', cd_motivo_alta_w, reg_integracao_w.nr_seq_regra_conversao, reg_integracao_w.ie_conversao, 'E'), 'N', r_inpat_discharge_data_w.movemnttype); --OS 1751858
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_SAIDA_UNIDADE', 'movemntdate', 'N', c01_w.dt_saida_unidade, 'N', dt_geral_w);
		r_inpat_discharge_data_w.movemntdate	:=	to_char(to_date(dt_geral_w),'yyyy-mm-dd');
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_SAIDA_UNIDADE', 'movemnttime', 'N', c01_w.dt_saida_unidade, 'N', dt_geral_w);
		r_inpat_discharge_data_w.movemnttime	:=	to_char(to_date(dt_geral_w),'hh24:mi:ss');
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_MOTIVO_ALTA', 'movemntreas1', 'N', c01_w.cd_motivo_alta, 'S', r_inpat_discharge_data_w.movemntreas1);	
		
		reg_integracao_w.nm_tabela 	:= 'SUBMOTIVO_ALTA';
		begin
		select	max(a.nr_seq_submotivo)
		into STRICT	nr_seq_submotivo_w
		from	submotivo_alta a
		where	a.nr_sequencia = nr_submotivo_alta_w;
		exception
		when others then
			nr_seq_submotivo_w	:= null;
		end;
		
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_SUBMOTIVO', 'movemntreas2', 'N', nr_seq_submotivo_w, 'S', r_inpat_discharge_data_w.movemntreas2);
		
		reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
		r_inpat_discharge_data_w.statusind	:=	null; /*"p" plan or "blank" real*/
		
		select	*
		into STRICT	atendimento_paciente_w
		from	atendimento_paciente
		where	nr_atendimento = c01_w.nr_atendimento;
		
		--intpd_processar_atrib_envio(reg_integracao_w, 'NR_SUBMOTIVO_ALTA', 'dischrgdisp', 'N', atendimento_paciente_w.nr_submotivo_alta, 'S', r_inpat_discharge_data_w.dischrgdisp);
		intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_ATENDIMENTO', 'emergadm', 'N', atendimento_paciente_w.ie_tipo_atendimento, 'N', ie_tipo_atendimento_w);
		if (ie_tipo_atendimento_w = '3') then
			r_inpat_discharge_data_w.emergadm	:= 'X';
		end if;
		intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_ATENDIMENTO', 'emergadmx', 'S', atendimento_paciente_w.ie_tipo_atendimento, 'N', r_inpat_discharge_data_w.emergadmx);
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_ATUALIZACAO', 'creationdate', 'N', atendimento_paciente_w.dt_atualizacao, 'N', dt_geral_w);
		r_inpat_discharge_data_w.creationdate	:= to_char(to_date(dt_geral_w),'yyyy-mm-dd');
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_ATUALIZACAO', 'creationtime', 'N', atendimento_paciente_w.dt_atualizacao, 'N', dt_geral_w);
		r_inpat_discharge_data_w.creationtime	:= to_char(to_date(dt_geral_w),'hh24:mi:ss');
		intpd_processar_atrib_envio(reg_integracao_w, 'NM_USUARIO_NREC', 'creationuser', 'N', ish_param_pck.get_nm_usuario, 'N', r_inpat_discharge_data_w.creationuser);

		select	max(nr_sequencia),
			substr(max(ds_observacao),1,30)
		into STRICT	nr_sequencia_w,
			ds_observacao_w
		from	episodio_paciente
		where	nr_sequencia in (SELECT x.nr_seq_episodio from atendimento_paciente x where x.nr_atendimento = c01_w.nr_atendimento);
		
		reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_TRANSF';
		begin
		select	lpad(ltrim(a.cd_cgc,'0'),10,'0')
		into STRICT	cd_hospital_destino_w
		from	atendimento_transf a
		where	a.nr_atendimento = c01_w.nr_atendimento
		and	a.nr_sequencia = (SELECT max(x.nr_sequencia) from atendimento_transf x where x.nr_atendimento = a.nr_atendimento);
		exception
		when others then
			cd_hospital_destino_w	:= null;	
		end;
		
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_CGC', 'refhospital', 'N', cd_hospital_destino_w, 'N', r_inpat_discharge_data_w.refhospital);
		
		reg_integracao_w.nm_tabela 	:= 'EPISODIO_PACIENTE';
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA', 'extcaseid', 'N', nr_sequencia_w, 'N', r_inpat_discharge_data_w.extcaseid);
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_OBSERVACAO', 'casecomment', 'N', ds_observacao_w, 'N', r_inpat_discharge_data_w.casecomment);
		
		select	max(dt_alta_curativo)
		into STRICT	dt_alta_curativo_w
		from	cur_ferida
		where	nr_atendimento = c01_w.nr_atendimento
		and	(dt_alta_curativo IS NOT NULL AND dt_alta_curativo::text <> '');
		
		reg_integracao_w.nm_tabela 	:= 'CUR_FERIDA';
		dt_geral_w	:= null;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_ALTA_CURATIVO', 'healeddate', 'N', dt_alta_curativo_w, 'N', dt_geral_w);
		r_inpat_discharge_data_w.healeddate	:= to_char(to_date(dt_geral_w),'yyyy-mm-dd');
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_ALTA_CURATIVO', 'healeddatex', 'S', dt_alta_curativo_w, 'N', r_inpat_discharge_data_w.healeddatex);
	--	r_inpat_discharge_data_w.refpsttrttype		:=	intpd_conv('CLASSIFICACAO_ATENDIMENTO','NR_SEQUENCIA', c01_w.nr_seq_classificacao, nr_seq_regra_w, ie_conversao_w, 'E'); /*only need to outpatient process. 116 billing regulation. it is a catalog. treatment type.*/
		
	--	r_inpat_discharge_data_w.workincapacity	:=		
	--	r_inpat_discharge_data_w.movemntreas2	:=	
		
		r_inpat_discharge_data_w.respiration		:=	ish_obter_tempo_respiracao(atendimento_paciente_w.nr_seq_episodio);
		r_inpat_discharge_data_w.respirationx		:=	'X';
		reg_integracao_w.nm_tabela 	:= 'ATEND_PACIENTE_UNIDADE';
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'extmovementid', 'N', c01_w.nr_seq_interno, 'N', r_inpat_discharge_data_w.extmovementid);
		
		select	max(a.cd_medico_dest)
		into STRICT	cd_medico_dest_w
		from	atendimento_alta a, parametro_medico p
		where	nr_atendimento = c01_w.nr_atendimento
		and     p.cd_estabelecimento = obter_estabelecimento_ativo
		and 	((a.ie_tipo_orientacao <> 'P')
		or (coalesce(p.ie_liberar_desfecho,'N')  = 'N')
		or  	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and (coalesce(a.dt_inativacao::text, '') = '')));
		
		reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_ALTA';
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_MEDICO_DEST', 'postdisphys', 'N', cd_medico_dest_w, 'S', r_inpat_discharge_data_w.postdisphys);
		reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
		nm_usuario_alta_medica_w	:= substr(obter_dados_usuario_opcao(c01_w.nm_usuario_alta_medica,'C'),1,10);
		--intpd_processar_atrib_envio(reg_integracao_w, 'NM_USUARIO_ALTA_MEDICA', 'disphys', 'N', nm_usuario_alta_medica_w, 'S', r_inpat_discharge_data_w.disphys);
		
		select	max(qt_peso),
			max(qt_altura_cm)
		into STRICT	qt_peso_w,
			qt_altura_cm_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = c01_w.cd_pessoa_fisica;	
		end;
		
		intpd_processar_atrib_envio(reg_integracao_w, 'QT_PESO', 'patweight', 'N', qt_peso_w, 'N', qt_peso_str_w);
		r_inpat_discharge_data_w.patweight	:=	replace(qt_peso_str_w,',','.');
		--r_inpat_discharge_data_w.weightunit	:= 'kg'; 
		r_inpat_discharge_data_w.weightunitiso	:= 'KGM'; --OS 1956899
		intpd_processar_atrib_envio(reg_integracao_w, 'QT_ALTURA_CM', 'patheight', 'N', qt_altura_cm_w, 'N', r_inpat_discharge_data_w.patheight);
		--r_inpat_discharge_data_w.heightunit	:= 'cm';
		r_inpat_discharge_data_w.heightunitiso	:= 'CMT';  --OS 1956899
	end loop;
	close c01;
end if;

RETURN NEXT r_inpat_discharge_data_w;
CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_pat_case_pck.get_inpat_discharge_data ( nr_seq_fila_p bigint) FROM PUBLIC;