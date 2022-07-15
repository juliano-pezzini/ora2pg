-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_bi_reembolso_towers ( nr_seq_arq_informacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

			 
ds_sql_w			varchar(32000);
ds_filtros_w			varchar(4000);
ds_filtros_mat_w		varchar(4000);
var_cur_w			integer;
var_exec_w			integer;
var_retorno_w			integer;
arquivos_bi_filtros_w		pls_arquivos_bi_filtros%rowtype;
arquivos_bi_inf_w		pls_arquivos_bi_inf%rowtype;
dt_rescisao_w			timestamp;
dt_contratacao_w		timestamp;
dt_ultimo_hist_reativacao_w	timestamp;
dt_ultimo_hist_inativo_w	timestamp;
ie_tipo_historico_w		varchar(10);
nm_id_sid_w			pls_arquivos_bi_inf.nm_id_sid%type;
nm_id_serial_w			pls_arquivos_bi_inf.nm_id_serial%type;
arq_texto_w			utl_file.file_type;
ds_local_w			varchar(255) := null;
ds_erro_w			varchar(255);
qt_registros_w			bigint;
ds_log_w  			varchar(4000);
ds_linha_w			varchar(10000);
dt_inicial_w			timestamp;
dt_final_w			timestamp;
------------------------------------------------------------------------------------------------------------------------------ 
cd_usuario_plano_w		pls_segurado_carteira.cd_usuario_plano%type;
cd_usuario_plano_ww		pls_segurado_carteira.cd_usuario_plano%type;
ds_tipo_contratacao_w		varchar(60);
ds_plano_w			varchar(255);
ie_sexo_w			pessoa_fisica.ie_sexo%type;
dt_inclusao_operadora_w		timestamp;
dt_nascimento_w			timestamp;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
ds_uf_w				varchar(255);
ds_regiao_w			pls_regiao_arq_bi.ds_regiao%type;
ds_segmentacao_w		valor_dominio.ds_valor_dominio%type;
cd_cgc_estipulante_w		pls_contrato.cd_cgc_estipulante%type;
ie_preco_w			varchar(60);
nr_seq_titular_w		pls_segurado.nr_seq_titular%type;
ie_situacao_trabalhista_w	varchar(60);
nr_cpf_w			pessoa_fisica.nr_cpf%type;
ds_titular_w			varchar(60);
ds_parentesco_w			varchar(60);
cd_guia_w			pls_conta.cd_guia%type;
dt_atendimento_w		pls_conta.dt_atendimento%type;
dt_alta_w			pls_conta.dt_alta%type;
ie_tipo_w			varchar(1);
nr_seq_segurado_w		pls_conta.nr_seq_segurado%type;
cd_procedimento_w		pls_conta_proc.cd_procedimento%type;
ie_tipo_despesa_w		pls_conta_proc.ie_tipo_despesa%type;
vl_calculado_w			pls_conta_proc.vl_procedimento%type;
vl_apresentado_w		pls_conta_proc.vl_procedimento_imp%type;
vl_liberado_w			pls_conta_proc.vl_liberado%type;
cd_guia_referencia_w		pls_conta.cd_guia_referencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_prestador_w		pls_conta.nr_seq_prestador%type;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
nr_seq_tipo_atendimento_w	pls_conta.nr_seq_tipo_atendimento%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
nr_seq_preco_produto_w		pls_preco_produto.nr_sequencia%type;
cd_subgrupo_produto_w		pls_preco_produto.cd_subgrupo_produto%type;
ds_procedimento_w		procedimento.ds_procedimento%type;
vl_aux_w			pls_conta_proc_aprop.vl_apropriado%type;
vl_pago_usuario_w		pls_conta_proc_aprop.vl_apropriado%type;
vl_pago_empresa_w		pls_conta_proc_aprop.vl_apropriado%type;
vl_pago_plano_w			pls_conta_proc_aprop.vl_apropriado%type;
ie_responsavel_aprop_w		pls_centro_apropriacao.ie_responsavel_apropriacao%type;
cd_doenca_w			pls_diagnostico_conta.cd_doenca%type;
cd_pessoa_fisica_prestador_w	pls_prestador.cd_pessoa_fisica%type;
ds_tipo_atendimento_w		pls_tipo_atendimento.ds_tipo_atendimento%type;
cd_cgc_prestador_w		pls_prestador.cd_cgc%type;
ie_tipo_relacao_w		varchar(60);
ds_prestador_ops_w		pls_prestador.nm_interno%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
dt_ocorr_evento_w		timestamp;
dt_protocolo_w			pls_protocolo_conta.dt_protocolo%type;
dt_liquidacao_w			titulo_pagar.dt_liquidacao%type;
ds_grupo_receita_w		grupo_receita.ds_grupo_receita%type;
nr_seq_grupo_rec_w		procedimento.nr_seq_grupo_rec%type;
vl_procedimento_imp_w		pls_conta_proc.vl_procedimento_imp%type;
ie_tipo_guia_w			varchar(60);
ds_prestador_con_w		varchar(255);
ie_tipo_endereco_w		pls_prestador.ie_tipo_endereco%type;
nr_lote_mensalidade_w 		pls_lote_mensalidade.nr_sequencia%type;
vl_liberado_aux_w		double precision;
cd_servico_w			varchar(30);
ie_origem_proced_w		pls_conta_proc.ie_origem_proced%type;
nr_titulo_w			titulo_receber.nr_titulo%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;

bind_sql_w			sql_pck.t_dado_bind;
bind_w				sql_pck.t_dado_bind;

cursor_w			sql_pck.t_cursor;
cursor_sql_w			sql_pck.t_cursor;		
		 
procedure grava_log_erro(	ds_erro_p	text, 
				ds_stack_p  	text) is 

;
BEGIN
 
-- Obter o log a ser gravado 
ds_log_w := substr('Erro: ' || ds_erro_p || pls_util_pck.enter_w || 
		  'Stack: ' || ds_stack_p, 1, 4000);
  
-- coloca com status de processado com erros. 
update	pls_arquivos_bi_inf 
set	ie_status		= 'E', 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp(), 
	DT_FIM_GERACAO		= clock_timestamp(), 
	ds_erro			= ds_log_w 
where	nr_sequencia 		= nr_seq_arq_informacao_p;
 
commit;
 
CALL wheb_mensagem_pck.exibir_mensagem_abort(306247);
 
end;
 
begin 
 
select	sid, 
	serial# 
into STRICT	nm_id_sid_w, 
	nm_id_serial_w 
from	v$session 
where 	audsid = userenv('SESSIONID');
 
-- coloca com status em processamento. 
update	pls_arquivos_bi_inf 
set	ie_status		= 'P', 
	nm_id_sid		= nm_id_sid_w, 
	nm_id_serial		= nm_id_serial_w, 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp(), 
	DT_INICIO_GERACAO	= clock_timestamp() 
where	nr_sequencia 		= nr_seq_arq_informacao_p;
commit;
 
select	* 
into STRICT	arquivos_bi_inf_w 
from	pls_arquivos_bi_inf 
where	nr_sequencia	= nr_seq_arq_informacao_p;
 
select	* 
into STRICT	arquivos_bi_filtros_w 
from	pls_arquivos_bi_filtros 
where	nr_sequencia	= arquivos_bi_inf_w.nr_seq_arq_filtros;
 
 
dt_inicial_w	:= arquivos_bi_filtros_w.dt_inicial;
dt_final_w	:= arquivos_bi_filtros_w.dt_final;
 
dt_inicial_w	:= trunc(dt_inicial_w,'dd');
dt_final_w	:= fim_dia(dt_final_w);
 
begin 
SELECT * FROM obter_evento_utl_file(8, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
exception 
when others then 
	ds_local_w := null;
end;
 
if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
	CALL grava_log_erro(ds_erro_w,dbms_utility.format_error_backtrace);
end if;
 
begin 
arq_texto_w := utl_file.fopen(ds_local_w,arquivos_bi_inf_w.nm_arquivo,'w');
exception 
when others then 
	 
	ds_erro_w := obter_erro_utl_open(SQLSTATE);
	 
	CALL grava_log_erro(ds_erro_w,dbms_utility.format_error_backtrace);
end;
 
 
if (arquivos_bi_filtros_w.nr_seq_plano IS NOT NULL AND arquivos_bi_filtros_w.nr_seq_plano::text <> '') then 
	ds_filtros_w	:= ds_filtros_w||' and a.nr_seq_plano = :nr_seq_plano ';
end if;
 
if (arquivos_bi_filtros_w.nr_seq_grupo_produto IS NOT NULL AND arquivos_bi_filtros_w.nr_seq_grupo_produto::text <> '') then 
	ds_filtros_w	:= ds_filtros_w||' and substr(pls_se_grupo_preco_produto(:nr_seq_grupo_produto,a.nr_seq_plano),1,255) = ''S''';
end if;
 
if (arquivos_bi_filtros_w.nr_seq_contrato IS NOT NULL AND arquivos_bi_filtros_w.nr_seq_contrato::text <> '') then 
	ds_filtros_w	:= ds_filtros_w||' and d.nr_seq_contrato = :nr_seq_contrato ';
end if;
 
if (arquivos_bi_filtros_w.nr_seq_grupo_contrato IS NOT NULL AND arquivos_bi_filtros_w.nr_seq_grupo_contrato::text <> '') then 
	ds_filtros_w	:= ds_filtros_w||' and exists (	select 1 
						from	PLS_CONTRATO_GRUPO x 
						where	x.nr_seq_contrato 	= d.nr_seq_contrato 
						and	x.nr_seq_grupo		= :nr_seq_grupo)';
end if;
 
ds_sql_w	:= 	'select	''P'',				'	|| 
			'	a.nr_seq_segurado,		'	|| 
			'	b.cd_procedimento,	 	'	||			 
			'	nvl(a.cd_guia,a.cd_guia_prestador), '	||	 
			'	a.dt_atendimento,	 	'	||	 
			'	a.dt_alta,		 	'	||	 
			'	b.ie_tipo_despesa,	 	'	||	 
			'	b.vl_procedimento,	 	'	||	 
			'	b.vl_procedimento_imp,	 	'	||	 
			'	b.vl_liberado,		 	'	||	 
			'	a.cd_guia_referencia,	 	'	|| 
			'	a.nr_sequencia,			'	|| 
			'	a.nr_seq_prestador_exec,	'	|| 
			'	b.nr_sequencia,			'	|| 
			'	a.nr_seq_tipo_atendimento,	'	|| 
			'	b.dt_procedimento,		'	|| 
			'	c.dt_protocolo,			'	|| 
			'	obter_valor_dominio(1746,c.ie_tipo_guia), '|| 
			'	substr(pls_obter_cod_prestador(a.nr_seq_prestador_exec,null),1,255), 	'	|| 
			'	(select max(f.nr_sequencia) from pls_lote_mensalidade f,   		'  || 
			'           pls_mensalidade g,					'  || 
			'           pls_mensalidade_segurado h,				'  || 
			'           pls_mensalidade_seg_item i				'  || 
			'           where g.nr_seq_lote    = f.nr_sequencia		'  || 
			'           and  h.nr_seq_mensalidade = g.nr_sequencia		'  ||                                     
			'           and  i.nr_seq_mensalidade_seg = h.nr_sequencia		'  || 
			'           and  i.nr_seq_conta = a.nr_sequencia			'  ||	 
			'           ),							'  || 
			'	b.ie_origem_proced, '  || 
			'	c.nr_sequencia nr_seq_protocolo ' || 
			'from	pls_conta		a,	'	|| 
			'	pls_conta_proc		b,	'	||			 
			'	pls_protocolo_conta	c,	'	|| 
			'	pls_segurado		d	'	|| 
			'where	a.nr_sequencia 		= b.nr_seq_conta	'	|| 
			'and	c.nr_sequencia 		= a.nr_seq_protocolo '	|| 
			' and	a.nr_seq_segurado	= d.nr_sequencia	' || 
			' and	c.DT_MES_COMPETENCIA	between :dt_inicial and :dt_final ' || 
			' and	c.IE_STATUS		in (''3'',''5'',''6'')	' || 
			'and	c.ie_tipo_protocolo = ''R'' 	'	||ds_filtros_w|| 
			'union all '					|| 
			'select	''M'',				'	|| 
			'	a.nr_seq_segurado,		'	|| 
			'	b.nr_seq_material cd_procedimento,'	|| 
			'	nvl(a.cd_guia,a.cd_guia_prestador),'	|| 
			'	a.dt_atendimento,	 	'	|| 
			'	a.dt_alta,		 	'	|| 
			'	b.ie_tipo_despesa,	 	'	|| 
			'	b.vl_material vl_calculado,	'	|| 
			'	b.vl_material_imp vl_procedimento_imp,	'|| 
			'	b.vl_liberado,		 	'	|| 
			'	a.cd_guia_referencia,	 	'	|| 
			'	a.nr_sequencia,			'	|| 
			'	a.nr_seq_prestador_exec,	'	|| 
			'	b.nr_sequencia,			'	|| 
			'	a.nr_seq_tipo_atendimento,	'	|| 
			'	b.dt_atendimento,		'	|| 
			'	c.dt_protocolo,			'	|| 
			'	obter_valor_dominio(1746,c.ie_tipo_guia), '|| 
			'	substr(pls_obter_cod_prestador(a.nr_seq_prestador_exec,null),1,255), 	'	|| 
			'	(select max(f.nr_sequencia) from pls_lote_mensalidade f,   		'  || 
			'           pls_mensalidade g,					'  || 
			'           pls_mensalidade_segurado h,				'  || 
			'           pls_mensalidade_seg_item i				'  || 
			'           where g.nr_seq_lote    = f.nr_sequencia		'  || 
			'           and  h.nr_seq_mensalidade = g.nr_sequencia		'  ||                                     
			'           and  i.nr_seq_mensalidade_seg = h.nr_sequencia		'  || 
			'           and  i.nr_seq_conta = a.nr_sequencia			'  ||	 
			'           ),							'  || 
			'	null ie_origem_proced,	'  || 
			'	c.nr_sequencia nr_seq_protocolo	' || 
			'from	pls_conta		a,	'	|| 
			'	pls_conta_mat		b,	'	|| 
			'	pls_protocolo_conta	c,	'	|| 
			'	pls_segurado		d	'	|| 
			'where	a.nr_sequencia = b.nr_seq_conta	'	|| 
			'and	c.nr_sequencia = a.nr_seq_protocolo '	|| 
			' and	a.nr_seq_segurado	= d.nr_sequencia	' || 
			' and	c.DT_MES_COMPETENCIA	between :dt_inicial and :dt_final ' || 
			' and	c.IE_STATUS		in (''3'',''5'',''6'')	' || 
			'and	c.ie_tipo_protocolo = ''R'' 	'	||ds_filtros_w;
	 
begin	 
 
	utl_file.put_line(arq_texto_w, 'SEGMENTO;TIPO DE PLANO;CODIGO DO PLANO;CNPJ DA EMPRESA;TIPO DE CONTRATO;NUMERO IDENTIFICACAO TITULAR;'|| 
					'NUMERO IDENTIFICACAO USUARIO;CPF DO USUARIO;TITULARIDADE;TIPO DE BENEFICIARIO;TIPO DE USUARIO;NUMERO DA OCORRENCIA/SENHA;'|| 
					'NUMERO DA GUIA;DATA OCORRENCIA EVENTO;DATA AVISO EVENTO;DATA PAGAMENTO EVENTO;DATA ALTA INTERNACAO;UF REGIAO DESPESA;'|| 
					'ORIGEM DESPESA;CODIGO PRESTADOR;TIPO EVENTO;CID;CODIGO PROCEDIMENTO;DESCRICAO PROCEDIMENTO;'|| 
					'VALOR CALCULADO;VALOR APRESENTADO;VALOR PAGO;VALOR PAGO USUARIO;VALOR PAGO EMPRESA;VALOR PAGO PLANO;'|| 
					'TIPO GUIA;TITULO;' || chr(13));
	utl_file.fflush(arq_texto_w);
 
	bind_w.delete;
	bind_w := sql_pck.bind_variable(	':dt_inicial', dt_inicial_w, bind_w);
 
	bind_w := sql_pck.bind_variable(	':dt_final', dt_final_w, bind_w, sql_pck.b_data_hora);
	 
	if (arquivos_bi_filtros_w.nr_seq_plano IS NOT NULL AND arquivos_bi_filtros_w.nr_seq_plano::text <> '') then	 
		bind_w := sql_pck.bind_variable(	':nr_seq_plano', arquivos_bi_filtros_w.nr_seq_plano, bind_w);
	end if;
	 
	if (arquivos_bi_filtros_w.nr_seq_grupo_produto IS NOT NULL AND arquivos_bi_filtros_w.nr_seq_grupo_produto::text <> '') then 
		bind_w := sql_pck.bind_variable(':nr_seq_grupo_produto', arquivos_bi_filtros_w.nr_seq_grupo_produto, bind_w);
	end if;	
	 
	if (arquivos_bi_filtros_w.nr_seq_contrato IS NOT NULL AND arquivos_bi_filtros_w.nr_seq_contrato::text <> '') then 
		bind_w := sql_pck.bind_variable(':nr_seq_contrato', arquivos_bi_filtros_w.nr_seq_contrato, bind_w);
	end if;	
	 
	if (arquivos_bi_filtros_w.nr_seq_grupo_contrato IS NOT NULL AND arquivos_bi_filtros_w.nr_seq_grupo_contrato::text <> '') then 
		bind_w := sql_pck.bind_variable(':nr_seq_grupo', arquivos_bi_filtros_w.nr_seq_grupo_contrato, bind_w);
	end if;	
	 
	bind_w := sql_pck.executa_sql_cursor(ds_sql_w, bind_w);
	loop 
		fetch cursor_w into ie_tipo_w,nr_seq_segurado_w,cd_procedimento_w,cd_guia_w,dt_atendimento_w,dt_alta_w,ie_tipo_despesa_w,vl_calculado_w,vl_procedimento_imp_w, 
					vl_liberado_w,cd_guia_referencia_w,nr_seq_conta_w,nr_seq_prestador_w,nr_seq_conta_proc_w,nr_seq_tipo_atendimento_w, 
					dt_ocorr_evento_w,dt_protocolo_w,ie_tipo_guia_w,ds_prestador_con_w,nr_lote_mensalidade_w,ie_origem_proced_w,nr_seq_protocolo_w;
		 
		EXIT WHEN NOT FOUND; /* apply on cursor_w */
		dt_rescisao_w		:= trunc(dt_rescisao_w,'Month');
		dt_contratacao_w	:= trunc(dt_contratacao_w,'Month');
		 
		if	((coalesce(vl_calculado_w,0) + coalesce(vl_procedimento_imp_w,0) + coalesce(vl_liberado_w,0)) = 0) then 
			goto final;
		end if;
		 
		if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then 
			 
			select	a.nr_seq_contrato,				 
				b.cd_usuario_plano, 
				a.cd_pessoa_fisica, 
				CASE WHEN coalesce(a.nr_seq_titular::text, '') = '' THEN 'Titular'  ELSE 'Dependente' END , 
				CASE WHEN coalesce(a.nr_seq_titular::text, '') = '' THEN 'Titular'  ELSE c.ds_parentesco END , 
				coalesce(obter_valor_dominio(3840,a.ie_situacao_atend),'Ativo'), 
				a.nr_seq_plano, 
				a.nr_seq_titular 
			into STRICT	nr_seq_contrato_w,				 
				cd_usuario_plano_w, 
				cd_pessoa_fisica_w, 
				ds_titular_w, 
				ds_parentesco_w, 
				ie_situacao_trabalhista_w, 
				nr_seq_plano_w, 
				nr_seq_titular_w 
			FROM pls_segurado a
LEFT OUTER JOIN pls_segurado_carteira b ON (a.nr_sequencia = b.nr_seq_segurado)
LEFT OUTER JOIN grau_parentesco c ON (a.nr_seq_parentesco = c.nr_sequencia)
WHERE a.nr_sequencia 		= nr_seq_segurado_w;
			 
			if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then 
				select	max(cd_cgc_estipulante) 
				into STRICT	cd_cgc_estipulante_w 
				from	pls_contrato 
				where	nr_sequencia = nr_seq_contrato_w 
				and	coalesce(dt_cancelamento::text, '') = '';
			end if;
			 
			if (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then 
				select	obter_valor_dominio(1666,ie_tipo_contratacao), 
					obter_valor_dominio(1665,ie_segmentacao), 
					CASE WHEN coalesce(nr_sequencia::text, '') = '' THEN ds_plano  ELSE nr_sequencia||'-'||coalesce(nm_fantasia,ds_plano) END , 
					obter_valor_dominio(1669,ie_preco) 
				into STRICT	ds_tipo_contratacao_w, 
					ds_segmentacao_w, 
					ds_plano_w, 
					ie_preco_w 
				from	pls_plano 
				where	nr_sequencia = nr_seq_plano_w;
			end if;
			 
			select	nr_cpf 
			into STRICT	nr_cpf_w 
			from	pessoa_fisica 
			where	cd_pessoa_fisica = cd_pessoa_fisica_w;
			 
			if (ie_tipo_w = 'P') then 
				begin 
				cd_servico_w	:= to_char(cd_procedimento_w);
				select	max(a.ds_procedimento), 
					max(a.nr_seq_grupo_rec) 
				into STRICT	ds_procedimento_w, 
					nr_seq_grupo_rec_w 
				from	procedimento a					 
				where	cd_procedimento 	= cd_procedimento_w 
				and	ie_origem_proced	= ie_origem_proced_w;
				exception 
				when others then 
					ds_procedimento_w := '';
					cd_servico_w	:= '';
				end;
				if (nr_seq_grupo_rec_w IS NOT NULL AND nr_seq_grupo_rec_w::text <> '') then 
					select	max(ds_grupo_receita) 
					into STRICT	ds_grupo_receita_w 
					from	grupo_receita 
					where	nr_sequencia = nr_seq_grupo_rec_w;
				else 
					ds_grupo_receita_w := null;
				end if;				
			else 
				begin 
				 
				select	coalesce(ds_material,''), 
					cd_material_ops, 
					CASE WHEN ie_tipo_despesa='1' THEN 'Gases Medicinais' WHEN ie_tipo_despesa='2' THEN 'Medicamentos' WHEN ie_tipo_despesa='3' THEN 'Materiais' WHEN ie_tipo_despesa='7' THEN 'OPM' END  
				into STRICT	ds_procedimento_w, 
					cd_servico_w, 
					ds_grupo_receita_w 
				from	pls_material 
				where	nr_sequencia = cd_procedimento_w;				
				exception			 
				when others then 
					ds_procedimento_w := '';
					cd_servico_w	:= '';
					ds_grupo_receita_w	:= null;
				end;						
			end if;
			 
			vl_pago_plano_w		:= 0;
			vl_pago_usuario_w	:= 0;
			vl_pago_empresa_w	:= 0;
			vl_liberado_aux_w	:= 0;
			 
			if (ie_tipo_w = 'M') then 
				select	count(1) 
				into STRICT	qt_registros_w 
				from	pls_conta_pos_estabelecido 
				where	nr_seq_conta_mat	= nr_seq_conta_proc_w 
				and	vl_beneficiario		< 0;
				 
				if (qt_registros_w	= 0) then 
					select	sum(coalesce(b.vl_apropriado,0)) 
					into STRICT	vl_pago_plano_w 
					from	pls_conta_mat_aprop	b, 
						pls_centro_apropriacao	a 
					where	b.nr_seq_centro_aprop	= a.nr_sequencia 
					and	b.nr_seq_conta_mat	= nr_seq_conta_proc_w 
					and	coalesce(a.ie_responsavel_apropriacao::text, '') = '';
					 
					select	sum(coalesce(b.vl_apropriado,0)) 
					into STRICT	vl_pago_usuario_w 
					from	pls_conta_mat_aprop	b, 
						pls_centro_apropriacao	a 
					where	b.nr_seq_centro_aprop	= a.nr_sequencia 
					and	b.nr_seq_conta_mat	= nr_seq_conta_proc_w 
					and	a.ie_responsavel_apropriacao = '1';
					 
					select	sum(coalesce(b.vl_apropriado,0)) 
					into STRICT	vl_pago_empresa_w 
					from	pls_conta_mat_aprop	b, 
						pls_centro_apropriacao	a 
					where	b.nr_seq_centro_aprop	= a.nr_sequencia 
					and	b.nr_seq_conta_mat	= nr_seq_conta_proc_w 
					and	a.ie_responsavel_apropriacao = '2' 
					and	a.nr_sequencia <> 5;
				end if;
				 
				if	coalesce(vl_pago_plano_w,0) = 0 then 
					select	sum(coalesce(cm.vl_liberado,0)) 
					into STRICT	vl_liberado_w 
					from	pls_conta_mat cm 
					where	nr_sequencia	= nr_seq_conta_proc_w;
				end if;
				 
				if (coalesce(vl_liberado_w,0) > 0) then 
					vl_pago_plano_w	:= vl_liberado_w - coalesce(vl_pago_usuario_w,0) - coalesce(vl_pago_empresa_w,0);
				end if;
			elsif (ie_tipo_w = 'P') then 
			 
				select	count(1) 
				into STRICT	qt_registros_w 
				from	pls_conta_pos_estabelecido 
				where	nr_seq_conta_proc	= nr_seq_conta_proc_w 
				and	vl_beneficiario		< 0;
			 
				if (qt_registros_w	= 0) then 
					select	sum(coalesce(b.vl_apropriado,0)) 
					into STRICT	vl_pago_plano_w 
					from	pls_conta_proc_aprop	b, 
						pls_centro_apropriacao	a 
					where	b.nr_seq_centro_aprop	= a.nr_sequencia 
					and	b.nr_seq_conta_proc	= nr_seq_conta_proc_w 
					and	coalesce(a.ie_responsavel_apropriacao::text, '') = '';
					 
					select	sum(coalesce(b.vl_apropriado,0)) 
					into STRICT	vl_pago_usuario_w 
					from	pls_conta_proc_aprop	b, 
						pls_centro_apropriacao	a 
					where	b.nr_seq_centro_aprop	= a.nr_sequencia 
					and	b.nr_seq_conta_proc	= nr_seq_conta_proc_w 
					and	a.ie_responsavel_apropriacao = '1';
					 
					select	sum(coalesce(b.vl_apropriado,0)) 
					into STRICT	vl_pago_empresa_w 
					from	pls_conta_proc_aprop	b, 
						pls_centro_apropriacao	a 
					where	b.nr_seq_centro_aprop	= a.nr_sequencia 
					and	b.nr_seq_conta_proc	= nr_seq_conta_proc_w 
					and	a.ie_responsavel_apropriacao = '2' 
					and 	a.nr_sequencia <> 5;
				end if;
				 
				if	coalesce(vl_pago_plano_w,0) = 0 then 
					select	sum(coalesce(cp.vl_liberado,0)) 
					into STRICT	vl_liberado_aux_w 
					from	pls_conta_proc cp 
					where	nr_sequencia	= nr_seq_conta_proc_w;
					 
					if (coalesce(vl_liberado_aux_w,0) > 0) then 
						vl_pago_plano_w	:= vl_liberado_aux_w - coalesce(vl_pago_usuario_w,0) - coalesce(vl_pago_empresa_w,0);
					end if;
				end if;
			end if;
			 
			select	max(cd_doenca) 
			into STRICT	cd_doenca_w 
			from	pls_diagnostico_conta 
			where	nr_seq_conta = nr_seq_conta_w;
			 
			if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then 
				select	cd_usuario_plano 
				into STRICT	cd_usuario_plano_ww 
				from 	pls_segurado_carteira 
				where	nr_seq_segurado = nr_seq_titular_w;
			else 
				cd_usuario_plano_ww := cd_usuario_plano_w;
			end if;
			 
			select	max(cd_pessoa_fisica), 
				max(cd_cgc),				 
				pls_obter_dados_prestador(max(nr_sequencia),'N'), 
				obter_valor_dominio(1668,max(ie_tipo_relacao)), 
				max(ie_tipo_endereco) 
			into STRICT	cd_pessoa_fisica_prestador_w, 
				cd_cgc_prestador_w,				 
				ds_prestador_ops_w, 
				ie_tipo_relacao_w, 
				ie_tipo_endereco_w 
			from 	pls_prestador 
			where	nr_sequencia = nr_seq_prestador_w;
			 
			if (cd_pessoa_fisica_prestador_w IS NOT NULL AND cd_pessoa_fisica_prestador_w::text <> '') then 
				ds_uf_w := ie_tipo_endereco_w;
			else 
				begin 
				select	max(sg_estado) 
				into STRICT	ds_uf_w				 
				from	pessoa_juridica 
				where	cd_cgc = cd_cgc_prestador_w;
				exception 
				when others then				 
					ds_uf_w			:= '';
				end;
			end if;
			 
			select	max(a.dt_liquidacao), 
				max(a.nr_titulo) 
			into STRICT	dt_liquidacao_w, 
				nr_titulo_w 
			from	titulo_pagar			a 
			where	a.nr_seq_reembolso		= nr_seq_protocolo_w;
				 
			 
			select	max(cd_tiss) ||' '|| max(ds_tipo_atendimento) 
			into STRICT	ds_tipo_atendimento_w 
			from	pls_tipo_atendimento 
			where	nr_sequencia = nr_seq_tipo_atendimento_w;
			 
			ds_linha_w	:= ds_tipo_contratacao_w||';'||ds_segmentacao_w||';'||ds_plano_w||';'||cd_cgc_estipulante_w||';'||ie_preco_w||';'||cd_usuario_plano_ww||';'|| 
					cd_usuario_plano_w||';'||nr_cpf_w||';'||ds_titular_w||';'||ds_parentesco_w||';'||ie_situacao_trabalhista_w||';'||''||';'|| 
					cd_guia_w||';'||to_char(dt_ocorr_evento_w,'dd/mm/yyyy')||';'||to_char(dt_protocolo_w,'dd/mm/yyyy')||';'||to_char(dt_liquidacao_w,'dd/mm/yyyy')||';'||to_char(dt_alta_w,'dd/mm/yyyy')||';'||ds_uf_w||';'|| 
					ie_tipo_relacao_w||';'||ds_prestador_con_w||';'||ds_grupo_receita_w||';'||cd_doenca_w||';'||cd_servico_w||';'||ds_procedimento_w||';'|| 
					vl_calculado_w||';'||vl_procedimento_imp_w||';'||vl_liberado_w||';'||vl_pago_usuario_w||';'||vl_pago_empresa_w||';'||vl_pago_plano_w||';'|| 
					ie_tipo_guia_w||';'||nr_titulo_w||';';
					 
			utl_file.put_line(arq_texto_w, ds_linha_w || chr(13));
			utl_file.fflush(arq_texto_w);	
		end if;
		 
		<<final>> 
		ds_linha_w	:= '';
	end loop;
	close cursor_w;
	 
	update	pls_arquivos_bi_inf 
	set	ie_status		= 'C', 
		dt_fim_geracao		= clock_timestamp() 
	where	nr_sequencia 		= nr_seq_arq_informacao_p;
	 
exception 
when others then	 
	CALL grava_log_erro(sqlerrm,dbms_utility.format_error_backtrace);
end;
if (cursor_w%isopen) then 
	close cursor_w;
end if;	
			 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_bi_reembolso_towers ( nr_seq_arq_informacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

