-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_rzv_insurance_pck.get_insurance_get_response ( nr_sequencia_p bigint) AS $body$
DECLARE


nr_seq_regra_w		intpd_eventos_sistema.nr_seq_regra_conv%type;
ie_conversao_w		intpd_eventos_sistema.ie_conversao%type;
reg_integracao_w	gerar_int_padrao.reg_integracao_conv;
nr_seq_sistema_w	intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w	intpd_eventos_sistema.nr_seq_projeto_xml%type;
ie_evento_w		intpd_fila_transmissao.ie_evento%type;

nr_seq_doc_origem_w	intpd_fila_transmissao.nr_seq_documento%type;
nr_seq_agrupador_w	intpd_fila_transmissao.nr_seq_agrupador%type;
ds_xml_w		text;
xml_w			xml;

insurtab_w 		xml;

dt_atualizacao_nrec_w	timestamp;
dt_atualizacao_w		timestamp;

nm_usuario_nrec_w		usuario.nm_usuario%type;
nm_usuario_w			usuario.nm_usuario%type;

pessoa_fisica_taxa_w		pessoa_fisica_taxa%rowtype;
atend_categoria_convenio_w	atend_categoria_convenio%rowtype;
pessoa_titular_convenio_w	pessoa_titular_convenio%rowtype;
nr_seq_episodio_w		episodio_paciente.nr_sequencia%type;
nr_seq_tipo_episodio_w		episodio_paciente.nr_seq_tipo_episodio%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%type;
cd_convenio_w			convenio.cd_convenio%type;
cd_convenio_empresa_w		convenio.cd_convenio%type;
cd_categoria_w			categoria_convenio.cd_categoria%type;
cd_estabelecimento_w		atendimento_paciente.cd_estabelecimento%type;
nr_seq_tipo_admissao_fat_w	atendimento_paciente.nr_seq_tipo_admissao_fat%type;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
ie_obriga_pag_adic_w		pessoa_fisica_taxa.ie_obriga_pag_adicional%type;
current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10)			varchar(10)	:=	ish_param_pck.get_separador;

ds_erro_w		varchar(2000);
nr_seq_documento_w	varchar(80);
qt_categoria_w			bigint;
nr_seq_pf_taxa_w		bigint;

ie_status_w			intpd_fila_transmissao.ie_status%type		:=	'S';
ie_tipo_erro_w			intpd_fila_transmissao.ie_tipo_erro%type	:=	'F';

c01 CURSOR FOR
	SELECT	*
	from	xmltable('/InsurTab/item' passing insurtab_w columns
		client		varchar(3)		path		'Client',
		institution		varchar(4)		path		'Institution',
		patientid		varchar(10)		path		'Patientid',
		patcaseid		varchar(10)		path		'Patcaseid',
		lfdnr		varchar(3)		path		'Lfdnr',
		kostr		varchar(10)		path		'Kostr',
		patkz		varchar(1)		path		'Patkz',
		mgart		varchar(1)		path		'Mgart',
		verab		varchar(10)		path		'Verab',
		verbi		varchar(10)		path		'Verbi',
		rangf		varchar(2)		path		'Rangf',
		vkvst		varchar(4)		path		'Vkvst',
		vkvse		varchar(3)		path		'Vkvse',
		vknra		varchar(5)		path		'Vknra',
		vknum		varchar(9)		path		'Vknum',
		vcend		varchar(10)		path		'Vcend',
		vernr		varchar(20)		path		'Vernr',
		pflzz		varchar(1)		path		'Pflzz',
		vtrty		varchar(6)		path		'Vtrty',
		vernn		varchar(30)		path		'Vernn',
		vervn		varchar(30)		path		'Vervn',
		vergb		varchar(10)		path		'Vergb',
		agnam		varchar(30)		path		'Agnam',
		pstlz		varchar(10)		path		'Pstlz',
		stras		varchar(40)		path		'Stras',
		ort		varchar(40)		path		'Ort',
		lfdchg		varchar(3)		path		'Lfdchg',
		datchg		varchar(10)		path		'Datchg',
		abree		varchar(1)		path		'Abree',
		kvdat		varchar(10)		path		'Kvdat',
		verge		varchar(1)		path		'Verge',
		nzzgr		varchar(2)		path		'Nzzgr',
		vtage		varchar(2)		path		'Vtage',
		copreceipt	varchar(1)		path		'CopReceipt',
		ktrinstn		varchar(10)		path		'KtrInstn',
		ktrktart		varchar(3)		path		'KtrKtart',
		ktrname1		varchar(35)		path		'KtrName1',
		ktrname2		varchar(35)		path		'KtrName2',
		ktrname3		varchar(35)		path		'KtrName3',
		ktrland		varchar(3)		path		'KtrLand',
		ktrpstlz		varchar(10)		path		'KtrPstlz',
		ktrort		varchar(25)		path		'KtrOrt',
		storn		varchar(1)		path		'Storn'	
	);

c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	nr_atendimento,
	cd_estabelecimento,
	cd_pessoa_fisica,
	nr_seq_tipo_admissao_fat,
	ie_tipo_atendimento
from	atendimento_paciente
where	nr_seq_episodio = nr_seq_episodio_w;	


BEGIN
intpd_reg_integracao_inicio(nr_sequencia_p, 'R', reg_integracao_w);

delete	FROM intpd_log_recebimento
where	nr_seq_fila = nr_sequencia_p;

begin
select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_sistema,
	b.nr_seq_projeto_xml,
	b.nr_seq_regra_conv,
	a.ds_xml_retorno,
	a.ie_evento,
	a.nr_seq_agrupador
into STRICT	nr_seq_doc_origem_w,
	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_w,
	ds_xml_w,
	ie_evento_w,
	nr_seq_agrupador_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;
exception
when others then
	null;
end;

ish_converter_response(nr_sequencia_p, ds_xml_w, ie_status_w, ie_tipo_erro_w, xml_w);

if (ie_status_w = 'E') then
	update	intpd_fila_transmissao
	set	ie_status = ie_status_w,
		ie_tipo_erro = ie_tipo_erro_w,
		ie_response_procedure = 'S'
	where	nr_sequencia = nr_sequencia_p;
else
	begin
	select	a.insurtab
	into STRICT	insurtab_w
	from	xmltable(
			xmlnamespaces(
			'urn:sap-com:document:sap:soap:functions:mc-style' as "n0",
			'http://schemas.xmlsoap.org/soap/envelope/' as "soap-env"),
			'soap-env:Envelope/soap-env:Body/n0:_-rzvish_-insuranceGetResponse' passing xml_w columns
		insurtab xmltype path 'InsurTab') a;

	open c01;
	loop
	fetch c01 into	
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		CALL ish_lock_fila(ie_evento_w, c01_w.patcaseid);		
		
		atend_categoria_convenio_w	:=	null;
		pessoa_titular_convenio_w	:=	null;
		pessoa_fisica_taxa_w		:= 	null;
		
		select	max(nr_sequencia),
			max(nr_seq_tipo_episodio)
		into STRICT	nr_seq_episodio_w,
			nr_seq_tipo_episodio_w
		from	episodio_paciente
		
		where	nr_episodio = ltrim(c01_w.patcaseid, '0');

		open c02;
		loop
		fetch c02 into	
			nr_atendimento_w,
			cd_estabelecimento_w,
			cd_pessoa_fisica_w,
			nr_seq_tipo_admissao_fat_w,
			ie_tipo_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			cd_categoria_w 			:=	null;
			atend_categoria_convenio_w	:=	null;
		
			begin
			select	cd_convenio
			into STRICT	cd_convenio_w
			from	convenio
			where	cd_cgc = c01_w.kostr;
			exception
			when others then
				begin
				if (c01_w.patkz = 'X') then				

					select	max(cd_convenio_partic),
						max(cd_categoria_partic)
					into STRICT	cd_convenio_w,
						cd_categoria_w
					from	parametro_faturamento
					where	cd_estabelecimento = cd_estabelecimento_w;
					
					if (coalesce(cd_convenio_w::text, '') = '') then			
						select	min(cd_convenio)
						into STRICT	cd_convenio_w
						from	convenio
						where	ie_tipo_convenio = 1
						and	ie_situacao = 'A';
					end if;
				end if;		
						
				if (coalesce(cd_convenio_w::text, '') = '') then
					reg_integracao_w.intpd_log_receb[reg_integracao_w.qt_reg_log].ds_log := substr(	wheb_mensagem_pck.get_texto(736986,
															'DS_ELEMENTO=_-rzvish_-insuranceGet' ||
															';DS_ATRIBUTO=Kostr' ||
															';NR_SEQ_REGRA='||reg_integracao_w.nr_seq_regra_conversao ||
															';NM_TABELA=CONVENIO' ||
															';NM_ATRIBUTO=CD_CONVENIO' ||
															';DS_VALOR=' || c01_w.kostr),1,4000);
					reg_integracao_w.qt_reg_log	:= reg_integracao_w.qt_reg_log + 1;
				end if;
				end;
			end;
		
			atend_categoria_convenio_w.dt_inicio_vigencia	:= to_date(c01_w.verab||'00:00:01','yyyy-mm-dd hh24:mi:ss');
			atend_categoria_convenio_w.dt_final_vigencia	:= to_date(c01_w.verbi||'23:59:59','yyyy-mm-dd hh24:mi:ss');

			begin
			select	*
			into STRICT	atend_categoria_convenio_w
			from	atend_categoria_convenio
			where	cd_convenio = cd_convenio_w
			and	nr_atendimento = nr_atendimento_w
			--and	trunc(dt_inicio_vigencia,'dd') = trunc(atend_categoria_convenio_w.dt_inicio_vigencia,'dd')
  LIMIT 1;
			exception
			when others then
				atend_categoria_convenio_w.nr_seq_interno	:=	null;
			end;			
			
			atend_categoria_convenio_w.dt_atualizacao	:= clock_timestamp();
			atend_categoria_convenio_w.nm_usuario		:= current_setting('ish_rzv_insurance_pck.usernametasy')::varchar(15);		
			
			reg_integracao_w.nm_tabela		:= 'ATEND_CATEGORIA_CONVENIO';
			reg_integracao_w.nm_elemento		:= 'InsurTab';
			
			intpd_processar_atributo(reg_integracao_w, 'NR_ATENDIMENTO', nr_atendimento_w, 'N', atend_categoria_convenio_w.nr_atendimento);
			intpd_processar_atributo(reg_integracao_w, 'CD_CONVENIO', cd_convenio_w, 'N', atend_categoria_convenio_w.cd_convenio);
			intpd_processar_atributo(reg_integracao_w, 'CD_USUARIO_CONVENIO', c01_w.vernr, 'N', atend_categoria_convenio_w.cd_usuario_convenio);
			intpd_processar_atributo(reg_integracao_w, 'CD_PLANO_CONVENIO', c01_w.vtrty, 'S', atend_categoria_convenio_w.cd_plano_convenio);
			intpd_processar_atributo(reg_integracao_w, 'IE_TIPO_CONVENIADO', c01_w.mgart, 'S', atend_categoria_convenio_w.ie_tipo_conveniado);
			intpd_processar_atributo(reg_integracao_w, 'NR_PRIORIDADE', c01_w.rangf, 'N', atend_categoria_convenio_w.nr_prioridade);

			if	((coalesce(atend_categoria_convenio_w.cd_convenio::text, '') = '') or (reg_integracao_w.ie_usou_valor_padrao = 'S')) and (c01_w.kostr IS NOT NULL AND c01_w.kostr::text <> '') then
				CALL wheb_usuario_pck.set_nm_usuario(current_setting('ish_rzv_insurance_pck.usernametasy')::varchar(15));
				nr_seq_documento_w	:= substr(c01_w.client|| current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10) ||c01_w.institution|| current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10) ||c01_w.kostr,1,80);
				CALL gerar_int_padrao.set_executando_recebimento('N');
				CALL ish_rzv_insurance_pck.gravar_integracao('330', nr_seq_documento_w, current_setting('ish_rzv_insurance_pck.usernametasy')::varchar(15));
				CALL gerar_int_padrao.set_executando_recebimento('S');
			end if;
			
			if (ie_tipo_atendimento_w = 1) then			
				begin
				select	x.nr_sequencia
				into STRICT	nr_seq_pf_taxa_w
				from (
					SELECT	nr_sequencia,
						dt_pagamento,
						dt_atualizacao
					from	pessoa_fisica_taxa
					where	nr_atendimento 	= atend_categoria_convenio_w.nr_atendimento
					and	nr_seq_atecaco	= atend_categoria_convenio_w.nr_seq_interno
					order by dt_pagamento desc, dt_atualizacao desc) x LIMIT 1;
				exception
				when others then
					nr_seq_pf_taxa_w := null;
				end;
				
				if (nr_seq_pf_taxa_w IS NOT NULL AND nr_seq_pf_taxa_w::text <> '') then
					select	*
					into STRICT	pessoa_fisica_taxa_w
					from 	pessoa_fisica_taxa
					where	nr_sequencia	= nr_seq_pf_taxa_w;
				end if;

				reg_integracao_w.nm_tabela		:= 'PESSOA_FISICA_TAXA';
				intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_JUSTIFICATIVA', c01_w.nzzgr, 'S', pessoa_fisica_taxa_w.NR_SEQ_JUSTIFICATIVA);
				intpd_processar_atributo(reg_integracao_w, 'QT_DIAS_PAGAMENTO', c01_w.vtage, 'N', pessoa_fisica_taxa_w.QT_DIAS_PAGAMENTO);
--				intpd_processar_atributo(reg_integracao_w, 'IE_OBRIGA_PAG_ADICIONAL', c01_w.pflzz, 'N', ie_obriga_pag_adic_w);
				if (c01_w.pflzz = 'X') then
					pessoa_fisica_taxa_w.ie_obriga_pag_adicional	:= 'S';
				else
					pessoa_fisica_taxa_w.ie_obriga_pag_adicional	:= 'N';
				end if;			
				pessoa_fisica_taxa_w.dt_atualizacao	:= clock_timestamp();
				pessoa_fisica_taxa_w.nm_usuario		:= current_setting('ish_rzv_insurance_pck.usernametasy')::varchar(15);	
			end if;

			if (c01_w.storn IS NOT NULL AND c01_w.storn::text <> '') then /* storn tag para o cancelamento do convenio */
				if (atend_categoria_convenio_w.nr_seq_interno IS NOT NULL AND atend_categoria_convenio_w.nr_seq_interno::text <> '') then
					delete	FROM atend_categoria_convenio
					where	nr_seq_interno	= atend_categoria_convenio_w.nr_seq_interno
					and		nr_atendimento	= nr_atendimento_w
					and		ish_rzv_insurance_pck.get_se_conv_integrado_case(nr_seq_episodio_w, cd_convenio) = 'S';
				else
					delete	FROM atend_categoria_convenio
					where	cd_convenio	= cd_convenio_w
					and		nr_atendimento	= nr_atendimento_w
					and		ish_rzv_insurance_pck.get_se_conv_integrado_case(nr_seq_episodio_w, cd_convenio) = 'S';
				end if;
			elsif (reg_integracao_w.qt_reg_log = 0) then
				begin
				if (atend_categoria_convenio_w.nr_seq_interno IS NOT NULL AND atend_categoria_convenio_w.nr_seq_interno::text <> '') then
					begin
					update	atend_categoria_convenio
					set	row = atend_categoria_convenio_w
					where	nr_seq_interno = atend_categoria_convenio_w.nr_seq_interno;
					end;
				else
					begin				
					if (coalesce(cd_categoria_w::text, '') = '') then
						select	max(cd_categoria)
						into STRICT	atend_categoria_convenio_w.cd_categoria
						from	categoria_convenio
						where	cd_convenio	= cd_convenio_w
						and	ie_situacao 	= 'A'
						and	obter_se_cat_lib_tipo_adm(nr_seq_tipo_admissao_fat_w, cd_convenio, cd_categoria) = 'S';
						
						--categoria e obritatorio, por isso se nao achar, busca a primeira
						if (coalesce(atend_categoria_convenio_w.cd_categoria::text, '') = '') then
							select	min(cd_categoria)
							into STRICT	atend_categoria_convenio_w.cd_categoria
							from	categoria_convenio
							where	cd_convenio 	= cd_convenio_w
							and	ie_situacao 	= 'A';
						end if;
					else
						atend_categoria_convenio_w.cd_categoria := cd_categoria_w;
					end if;
					
					select	nextval('atend_categoria_convenio_seq')
					into STRICT	atend_categoria_convenio_w.nr_seq_interno
					;				
			
					insert into atend_categoria_convenio values (atend_categoria_convenio_w.*);
					end;
				end if;
				
				if (ie_tipo_atendimento_w = 1) and (atend_categoria_convenio_w.nr_seq_interno IS NOT NULL AND atend_categoria_convenio_w.nr_seq_interno::text <> '') and (pessoa_fisica_taxa_w.ie_obriga_pag_adicional = 'S' or (pessoa_fisica_taxa_w.nr_seq_justificativa IS NOT NULL AND pessoa_fisica_taxa_w.nr_seq_justificativa::text <> '')) then
					if (nr_seq_pf_taxa_w IS NOT NULL AND nr_seq_pf_taxa_w::text <> '') then
						update	pessoa_fisica_taxa
						set	row = pessoa_fisica_taxa_w
						where	nr_sequencia	= nr_seq_pf_taxa_w;
					else
					
						select	nextval('pessoa_fisica_taxa_seq')
						into STRICT	pessoa_fisica_taxa_w.nr_sequencia
						;
						
						select	max(cd_pessoa_fisica)
						into STRICT	pessoa_fisica_taxa_w.cd_pessoa_fisica
						from	atendimento_paciente
						where	nr_atendimento	= atend_categoria_convenio_w.nr_atendimento;
						
						pessoa_fisica_taxa_w.nr_seq_atecaco		:= atend_categoria_convenio_w.nr_seq_interno;
						pessoa_fisica_taxa_w.nr_atendimento		:= atend_categoria_convenio_w.nr_atendimento;
						pessoa_fisica_taxa_w.dt_atualizacao_nrec	:= clock_timestamp();
						pessoa_fisica_taxa_w.nm_usuario_nrec		:= current_setting('ish_rzv_insurance_pck.usernametasy')::varchar(15);
					
						insert into pessoa_fisica_taxa values (pessoa_fisica_taxa_w.*);
					end if;
				end if;
				
				--grava a conversao
				CALL gerar_conv_meio_externo(null,
							'ATEND_CATEGORIA_CONVENIO',
							'NR_SEQ_INTERNO',
							atend_categoria_convenio_w.nr_seq_interno,
							substr( atend_categoria_convenio_w.nr_seq_interno|| current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10) || c01_w.lfdnr || current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10) || c01_w.rangf,1,40),
							null,
							nr_seq_regra_w,
							'A',
							'INTPDTASY');
				
				end;
			end if;	
			end;
		end loop;
		close c02;			
		end;	
	end loop;
	close c01;
	
	if (reg_integracao_w.qt_reg_log > 0) then
		begin
			
		rollback;
		
		update	intpd_fila_transmissao
		set	ie_status = 'E',
			ie_response_procedure = 'S',
			ds_log = ds_erro_w
		where	nr_sequencia = nr_sequencia_p;		
		end;
	else
		update	intpd_fila_transmissao
		set	ie_status = 'S',
			nr_doc_externo = c01_w.patcaseid,
			ie_response_procedure = 'S',
			ds_log  = NULL
		where	nr_sequencia = nr_sequencia_p;
	end if;

	reg_integracao_w := gerar_int_padrao.gravar_log(reg_integracao_w);
	exception
	when others then
		begin
		ds_erro_w := substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,4000);
		
		rollback;
		
		update	intpd_fila_transmissao
		set	ie_status = 'E',
			ds_log = ds_erro_w,
			ie_response_procedure = 'S'
		where	nr_sequencia = nr_sequencia_p;
		end;
	end;
end if;

if (nr_seq_agrupador_w > 0) then
	CALL intpd_processar_fila_trans(null, 'S', nr_seq_agrupador_w);
end if;
	
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_rzv_insurance_pck.get_insurance_get_response ( nr_sequencia_p bigint) FROM PUBLIC;