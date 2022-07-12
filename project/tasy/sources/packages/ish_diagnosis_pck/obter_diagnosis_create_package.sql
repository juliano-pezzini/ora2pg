-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_diagnosis_pck.obter_diagnosis_create ( nr_seq_fila_p bigint, ie_tipo_p text) RETURNS SETOF T_DIAGNOSIS AS $body$
DECLARE


r_diagnosis_row_w		r_diagnosis_row;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
nr_seq_diagnostico_w		diagnostico_doenca.nr_seq_interno%type;
nr_seq_diag_sup_w		diagnostico_doenca.nr_seq_interno%type;
nr_seq_interno_w		diagnostico_doenca.nr_seq_interno%type;
cd_doenca_w			diagnostico_doenca.cd_doenca%type;
ds_classificacao_aux_w		classificacao_diagnostico.ds_classificacao%type;
nr_seq_classificacao_w		classificacao_diagnostico.nr_sequencia%type;
ds_chave_fila_w			varchar(35);
diagnostico_doenca_chave_w	dbms_sql.varchar2_table;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
movemntseqno_w			varchar(100);
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
ie_tipo_episodio_w		varchar(15);
cd_pessoa_fisica_externo_w	pf_codigo_externo.cd_pessoa_fisica_externo%type;
cd_versao_w			varchar(100);

c00 CURSOR FOR
SELECT	row_number() OVER () + 800 id, --adiciona 800 para nao dar conflito com ISH
	nr_seq_interno,
	cd_doenca,
	cd_doenca_superior
from	diagnostico_doenca
where	nr_atendimento	= nr_atendimento_w
and	nr_seq_interno in (SELECT	x.nr_seq_interno  --CID pai
	from	diagnostico_doenca x
	where	x.nr_seq_interno	= nr_seq_diagnostico_w
	
union

	select	y.nr_seq_interno  --CID filho
	from	diagnostico_doenca x,
		diagnostico_doenca y
	where	x.nr_atendimento	= nr_atendimento_w
	and	x.nr_seq_interno	= nr_seq_diagnostico_w
	and	x.nr_atendimento	= y.nr_atendimento
	and	y.cd_doenca_superior	= x.cd_doenca
	and	coalesce(y.dt_inativacao::text, '') = '')
order by cd_doenca_superior nulls first;

c00_w	c00%rowtype;

-- ajustado

c01 CURSOR FOR
SELECT	a.nr_atendimento,
	d.nr_seq_interno nr_seq_interno,
	d.cd_doenca cd_doenca_atual,
	d.cd_doenca_superior,
	to_char(obter_data_doenca_versao(d.nr_seq_versao_cid),'YYYY') cd_versao_atual,
	obter_ultimo_catalogo_cid(c.cd_doenca_cid) cd_versao_anterior, -- nao temos controle do de-para de cids anteriores
	null cd_doenca_anterior,   -- nao temos controle do de-para de cids anteriores
	intpd_conv('DIAGNOSTICO_DOENCA', 'CD_MEDICO', d.cd_medico, nr_seq_regra_w, ie_conversao_w, 'E') cd_medico,
	substr(d.ds_diagnostico, 1, 49) shorttext,
	d.dt_diagnostico,
	to_char(coalesce(d.dt_cid, d.dt_diagnostico),'YYYY-MM-DD') diagcreatdate,
	to_char(coalesce(d.dt_cid, d.dt_diagnostico),'HH24:MI:SS') diagcreattime,
	d.ie_status_diag,
	d.ie_lado,
	a.cd_estabelecimento,
	a.nr_seq_episodio,
	obter_departamento_data(d.nr_atendimento, d.dt_diagnostico) movemntseqno,
	c.cd_versao,
	e.cd_empresa,
	d.ie_classificacao_doenca,
	to_char(d.dt_atualizacao, 'HH24:MI:SS') updatedate,
	d.ie_diag_referencia referraldia,
	d.ie_diag_tratamento treatmentdia,
	d.ie_diag_admissao admissiondia,
	d.ie_diag_alta dischargedia,
	d.ie_diag_princ_depart deptmaindia,
	d.ie_diag_princ_episodio hospmaindia,
	d.ie_diag_cirurgia surgerydia,
	d.ie_diag_trat_especial inttransdiag,
	d.IE_DIAG_TRAT_CERT,
	d.ie_diag_obito,
	substr(get_case_encounter_type(a.nr_seq_episodio, null, a.nr_atendimento, a.ie_tipo_atendimento),1,15) ie_tipo_atendimento,
	d.ie_relevante_drg
from	diagnostico_doenca d,
	atendimento_paciente a,
	cid_doenca c,
	estabelecimento e
where	a.nr_atendimento = d.nr_atendimento
and	c.cd_doenca_cid = d.cd_doenca
and	a.cd_estabelecimento = e.cd_estabelecimento
and	d.nr_seq_interno = c00_w.nr_seq_interno;

c01_w	c01%rowtype;


BEGIN
intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);

if (coalesce(nr_seq_fila_p,0) > 0) then
	select	a.nr_seq_documento,
		b.nr_seq_regra_conv,
		coalesce(b.ie_conversao,'I')
	into STRICT	ds_chave_fila_w,
		nr_seq_regra_w,
		ie_conversao_w
	from	intpd_fila_transmissao a,
		intpd_eventos_sistema b
	where	a.nr_seq_evento_sistema = b.nr_sequencia
	and	a.nr_sequencia = nr_seq_fila_p;	

	if (ie_tipo_p = 'I') then
		reg_integracao_w.nm_elemento	:= 'InputDiagnosis';
	elsif (ie_tipo_p = 'H') then
		reg_integracao_w.nm_elemento	:= 'urn:CasediagnosisCreatemult';
	end if;

	diagnostico_doenca_chave_w := obter_lista_string(ds_chave_fila_w, current_setting('ish_diagnosis_pck.ds_separador_w')::varchar(10));

	nr_atendimento_w	:= diagnostico_doenca_chave_w(1); --nr_atendimento
	nr_seq_diagnostico_w	:= diagnostico_doenca_chave_w(2); --nr_seq_interno
	cd_doenca_w		:= diagnostico_doenca_chave_w(3); --cd_doenca

	if (ie_tipo_p in ('I','H')) then

		open c00;
		loop
		fetch c00 into
			c00_w;
		EXIT WHEN NOT FOUND; /* apply on c00 */

			open c01;
			loop
			fetch c01 into
				c01_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				/*limpa todos os atributos do registro*/


				r_diagnosis_row_w := ish_diagnosis_pck.limpar_atributos_diagnosis(r_diagnosis_row_w);

				reg_integracao_w.nm_tabela 	:= 'ESTABELECIMENTO';
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'client', 'N', c01_w.cd_empresa, 'S', r_diagnosis_row_w.client);
				reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'institution', 'N', c01_w.cd_estabelecimento, 'S', r_diagnosis_row_w.institution);

                intpd_processar_atributo(reg_integracao_w,'NM_USUARIO_NREC',ish_param_pck.get_nm_usuario,'N',current_setting('ish_diagnosis_pck.usernameish')::varchar(15));

				begin
				select	lpad(nr_episodio,10,0),
					substr(obter_tipo_episodio(nr_sequencia),1,15)
				into STRICT 	r_diagnosis_row_w.patcaseid,
					ie_tipo_episodio_w
				from	episodio_paciente e
				where 	nr_sequencia = c01_w.nr_seq_episodio;
				exception
				when others then
					null;
				end;

				if (ie_tipo_p = 'H') then
					begin
					RETURN NEXT r_diagnosis_row_w;
					exit;
					end;
				end if;

				-- alteracoes thlima

				r_diagnosis_row_w.diagseqno	:= c00_w.id;

				--obtem a sequencia externa do nr_seq_atepacu que foi importado se existir

				reg_integracao_w.nm_tabela 	:= 'ATEND_PACIENTE_UNIDADE';
				--obtem a sequencia externa do nr_seq_atepacu que foi importado se existir

				movemntseqno_w	:= intpd_conv('ATEND_PACIENTE_UNIDADE', 'NR_SEQ_INTERNO', ish_diagnosis_pck.ish_obter_atepacu_data(c01_w.nr_atendimento,c01_w.dt_diagnostico), reg_integracao_w.nr_seq_regra_conversao, reg_integracao_w.ie_conversao, 'E');
				intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'movemntseqno', 'N', obter_valor_campo_separador(movemntseqno_w,2,current_setting('ish_diagnosis_pck.ds_separador_w')::varchar(10)), 'N', r_diagnosis_row_w.movemntseqno);

				--r_diagnosis_row_w.diagseqno	:= c01_w.cd_doenca;

				--r_diagnosis_row_w.extdiagno	:= c01_w.cd_doenca;

				--r_diagnosis_row_w.movemntseqno	:= c01_w.movemntseqno;

				reg_integracao_w.nm_tabela 	:= 'DIAGNOSTICO_DOENCA';

				/*begin
				select	nr_seq_interno
				into	nr_seq_diag_sup_w
				from	diagnostico_doenca
				where	nr_atendimento = nr_atendimento_w
				and	dt_diagnostico = c01_w.dt_diagnostico
				and	cd_doenca = c01_w.cd_doenca_superior;
				exception
				when others then
					nr_seq_diag_sup_w	:=	null;
				end;*/


				if (c00_w.id > 801) then --801, pois se for maior que a sequencaia 801, indica que e filho.
					intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'diagseqno', 'N', 801, 'N', r_diagnosis_row_w.dialink );
				end if;

				intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'extdiagno', 'N', c01_w.nr_seq_interno, 'N', r_diagnosis_row_w.extdiagno);
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_VERSAO_ATUAL', 'diagcatalog1', 'N',
					intpd_conv('CID_DOENCA_VERSAO', 'DT_VERSAO', c01_w.cd_versao_atual, reg_integracao_w.nr_seq_regra_conversao, reg_integracao_w.ie_conversao, 'E'), 'N', r_diagnosis_row_w.diagcatalog1);
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_DOENCA', 'diagkey1', 'N', ish_diagnosis_pck.get_diag(c01_w.nr_atendimento, c01_w.cd_doenca_atual, 'D'), 'N', r_diagnosis_row_w.diagkey1);
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_DOENCA', 'diagtyp1', 'N', ish_diagnosis_pck.get_diag(c01_w.nr_atendimento, c01_w.cd_doenca_atual, 'T'), 'N', r_diagnosis_row_w.diagtyp1);
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_VERSAO_ATUAL', 'diagcatalog2', 'N',
					intpd_conv('CID_DOENCA_VERSAO', 'DT_VERSAO', c01_w.cd_versao_anterior, reg_integracao_w.nr_seq_regra_conversao, reg_integracao_w.ie_conversao, 'E'), 'N', r_diagnosis_row_w.diagcatalog2);
				intpd_processar_atrib_envio(reg_integracao_w, 'DT_CID', 'diagcreatdate', 'N', c01_w.diagcreatdate, 'N', r_diagnosis_row_w.diagcreatdate);
				intpd_processar_atrib_envio(reg_integracao_w, 'DT_CID', 'diagcreattime', 'N', c01_w.diagcreattime, 'N', r_diagnosis_row_w.diagcreattime);
				if (coalesce(r_diagnosis_row_w.diagcreatdate,'NULL') = 'NULL') then
					intpd_processar_atrib_envio(reg_integracao_w, 'DT_DIAGNOSTICO', 'diagcreatdate', 'N', c01_w.diagcreatdate, 'N', r_diagnosis_row_w.diagcreatdate);
					intpd_processar_atrib_envio(reg_integracao_w, 'DT_DIAGNOSTICO', 'diagcreattime', 'N', c01_w.diagcreattime, 'N', r_diagnosis_row_w.diagcreattime);
				end if;

				r_diagnosis_row_w.creationuser	:= current_setting('ish_diagnosis_pck.usernameish')::varchar(15);
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_MEDICO', 'diagperson', 'N', c01_w.cd_medico, 'ISHMED', r_diagnosis_row_w.diagperson);

				if (c01_w.cd_doenca_superior IS NOT NULL AND c01_w.cd_doenca_superior::text <> '') then --Se for um CID filho, entao somente os ie_diag_referencia e ie_diag_tratamento devem ser enviados com base no pai.
					begin
					select	CASE WHEN coalesce(ie_diag_referencia,'N')='N' THEN null  ELSE 'S' END ,
						CASE WHEN coalesce(ie_diag_tratamento,'N')='N' THEN null  ELSE 'S' END
					into STRICT	r_diagnosis_row_w.referraldia,
						r_diagnosis_row_w.treatmentdia
					from	diagnostico_doenca
					where	nr_atendimento 	= nr_atendimento_w
					and	dt_diagnostico	= c01_w.dt_diagnostico
					and	cd_doenca 	= c01_w.cd_doenca_superior  LIMIT 1;
					exception
					when others then
						r_diagnosis_row_w.referraldia	:= null;
						r_diagnosis_row_w.treatmentdia	:= null;
					end;

					if (r_diagnosis_row_w.referraldia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_REFERENCIA','referraldia', 'N', 'S', 'N', r_diagnosis_row_w.referraldia);
						if (r_diagnosis_row_w.referraldia = 'S') then
							r_diagnosis_row_w.referraldia := 'X';
						else
							r_diagnosis_row_w.referraldia := null;
						end if;
					end if;

					if (r_diagnosis_row_w.treatmentdia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_TRATAMENTO','treatmentdia', 'N', 'S', 'N', r_diagnosis_row_w.treatmentdia);
						if (r_diagnosis_row_w.treatmentdia = 'S') then
							r_diagnosis_row_w.treatmentdia := 'X';
						else
							r_diagnosis_row_w.treatmentdia := null;
						end if;
					end if;

				else

					if (c01_w.referraldia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_REFERENCIA','referraldia', 'N', 'S', 'N', r_diagnosis_row_w.referraldia);
						if (r_diagnosis_row_w.referraldia = 'S') then
							r_diagnosis_row_w.referraldia := 'X';
						else
							r_diagnosis_row_w.referraldia := null;
						end if;
					end if;

					if (c01_w.treatmentdia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_TRATAMENTO','treatmentdia', 'N', 'S', 'N', r_diagnosis_row_w.treatmentdia);
						if (r_diagnosis_row_w.treatmentdia = 'S') then
							r_diagnosis_row_w.treatmentdia := 'X';
						else
							r_diagnosis_row_w.treatmentdia := null;
						end if;
					end if;

					if (c01_w.admissiondia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_ADMISSAO','admissiondia', 'N', 'S', 'N', r_diagnosis_row_w.admissiondia);
						if (r_diagnosis_row_w.admissiondia = 'S') then
							r_diagnosis_row_w.admissiondia := 'X';
						else
							r_diagnosis_row_w.admissiondia := null;
						end if;
					end if;
					
					if (coalesce(c01_w.ie_tipo_atendimento,'0') <> '1') then
						if (c01_w.IE_DIAG_TRAT_CERT = 'S') then
							intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_TRAT_CERT','dischargedia', 'N', 'S', 'N', r_diagnosis_row_w.dischargedia);
							if (r_diagnosis_row_w.dischargedia = 'S') then
								r_diagnosis_row_w.dischargedia := 'X';
							else
								r_diagnosis_row_w.dischargedia := null;
							end if;
						end if;
					elsif (c01_w.dischargedia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_ALTA','dischargedia', 'N', 'S', 'N', r_diagnosis_row_w.dischargedia);
						if (r_diagnosis_row_w.dischargedia = 'S') then
							r_diagnosis_row_w.dischargedia := 'X';
						else
							r_diagnosis_row_w.dischargedia := null;
						end if;
					end if;

					if (c01_w.deptmaindia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_PRINC_DEPART','deptmaindia', 'N', 'S', 'N', r_diagnosis_row_w.deptmaindia);
						if (r_diagnosis_row_w.deptmaindia = 'S') then
							r_diagnosis_row_w.deptmaindia := 'X';
						else
							r_diagnosis_row_w.deptmaindia := null;
						end if;
					end if;					

					if (c01_w.hospmaindia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_PRINC_EPISODIO','hospmaindia', 'N', 'S', 'N', r_diagnosis_row_w.hospmaindia);
						if (r_diagnosis_row_w.hospmaindia = 'S') then
							r_diagnosis_row_w.hospmaindia := 'X';
						else
							r_diagnosis_row_w.hospmaindia := null;
						end if;
					end if;

					if (c01_w.surgerydia = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_CIRURGIA','surgerydia', 'N', 'S', 'N', r_diagnosis_row_w.surgerydia);
						if (r_diagnosis_row_w.surgerydia = 'S') then
							r_diagnosis_row_w.surgerydia := 'X';
						else
							r_diagnosis_row_w.surgerydia := null;
						end if;
					end if;
					
					if (c01_w.ie_diag_obito = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_OBITO','causeofdeath', 'N', 'S', 'N', r_diagnosis_row_w.causeofdeath);
						if (r_diagnosis_row_w.causeofdeath = 'S') then
							r_diagnosis_row_w.causeofdeath := 'X';
						else
							r_diagnosis_row_w.causeofdeath := null;
						end if;
					end if;
					
					if (c01_w.inttransdiag = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_DIAG_TRAT_ESPECIAL','inttransdiag', 'N', 'S', 'N', r_diagnosis_row_w.inttransdiag);
						if (r_diagnosis_row_w.inttransdiag = 'S') then
							r_diagnosis_row_w.inttransdiag := 'X';
						else
							r_diagnosis_row_w.inttransdiag := null;
						end if;
					end if;
					
					/*if	(c01_w.ie_relevante_drg = 'S') then
						intpd_processar_atrib_envio(reg_integracao_w, 'IE_RELEVANTE_DRG','drgrelvant', 'N', 'S', 'N', r_diagnosis_row_w.DrgRelvant);
						if	(r_diagnosis_row_w.DrgRelvant = 'S') then
							r_diagnosis_row_w.DrgRelvant := 'X';
						else
							r_diagnosis_row_w.DrgRelvant := null;
						end if;
					end if;	*/


					if (coalesce(ie_tipo_episodio_w,'X') <> '8') and (c01_w.ie_relevante_drg = 'S') then						
						
						if (c01_w.hospmaindia = 'S') then
							intpd_processar_atrib_envio(reg_integracao_w, 'IE_CLASSIFICACAO_DOENCA', 'drgcategory', 'N', 'P', 'N', r_diagnosis_row_w.drgcategory);
						else
							intpd_processar_atrib_envio(reg_integracao_w, 'IE_CLASSIFICACAO_DOENCA', 'drgcategory', 'N', 'S', 'N', r_diagnosis_row_w.drgcategory);
						end if;
					else
						r_diagnosis_row_w.drgcategory	:= null;
					end if;					
				end if;

				reg_integracao_w.nm_tabela 	:= 'DIAGNOSTICO_DOENCA';
				intpd_processar_atrib_envio(reg_integracao_w, 'DS_DIAGNOSTICO', 'diagtext', 'N', c01_w.shorttext, 'N', r_diagnosis_row_w.diagtext);
				intpd_processar_atrib_envio(reg_integracao_w, 'CD_DOENCA', 'extdiagrefkey', 'N', ish_diagnosis_pck.get_diag(c01_w.nr_atendimento, c01_w.cd_doenca_atual, 'D'), 'N', r_diagnosis_row_w.extdiagrefkey);		-- que numero?

				/*select	ie_tipo_drg
				into	r_diagnosis_row_w.drgcategory		--
				from	episodio_paciente_drg
				where	nr_seq_episodio_paciente = c01_w.nr_seq_episodio;*/


				intpd_processar_atrib_envio(reg_integracao_w, 'IE_STATUS_DIAG', 'diagcertainty', 'N', c01_w.ie_status_diag, 'S', r_diagnosis_row_w.diagcertainty);
				intpd_processar_atrib_envio(reg_integracao_w, 'IE_LADO', 'diaglocation', 'N', c01_w.ie_lado, 'S', r_diagnosis_row_w.diaglocation);				

				RETURN NEXT r_diagnosis_row_w;
				end;

			end loop;
			close c01;

		end loop;
		close c00;
	end if;
end if;

CALL intpd_gravar_log_fila(reg_integracao_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_diagnosis_pck.obter_diagnosis_create ( nr_seq_fila_p bigint, ie_tipo_p text) FROM PUBLIC;
