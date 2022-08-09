-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_dados_inter_tiss ( nr_seq_fatura_p pls_fatura.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_tipo_arquivo_p w_pls_inconsistencia_int.ie_tipo_arquivo%type ) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Efetuar consistencia do XML TISS
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

qt_regra_w			integer;
ds_caminho_arquivo_w		pls_regra_arquivo_fatura.ds_caminho_arquivo%type;
ie_tipo_arquivo_w		pls_regra_arquivo_fatura.ie_tipo_arquivo%type;
cd_interface_w			pls_regra_arquivo_fatura.cd_interface%type;
ie_compactar_w			pls_regra_arquivo_fatura.ie_compactar%type;
nr_seq_esquema_xml_w		pls_regra_arquivo_fatura.nr_seq_esquema_xml%type;
nm_arquivo_w			pls_regra_arquivo_fatura.nm_arquivo%type;
nr_seq_regra_xml_w		pls_regra_arquivo_fatura.nr_sequencia%type;
ds_mascara_w			pls_regra_arquivo_fatura.nm_mascara_arquivo%type;
ds_mascara_zip_w		pls_regra_arquivo_fatura.nm_mascara_arquivo_zip%type;
ds_mascara_arq_adic_w		pls_regra_arquivo_fatura.nm_mascara_arquivo_adic%type;
ds_interface_w			pls_regra_arquivo_fatura.ds_interface%type;
ie_tipo_compactar_w		pls_regra_arquivo_fatura.ie_tipo_compactar%type;
ie_versao_xml_w			varchar(255);
nr_seq_lote_fat_guia_w		pls_lote_fat_guia_envio.nr_sequencia%type;
vl_tot_conta_w			pls_fat_guia_envio_proc.vl_beneficiario%type;
vl_faturado_w			pls_fatura_conta.vl_faturado%type;
vl_faturado_ndc_w		pls_fatura_conta.vl_faturado_ndc%type;
ds_conta_w			w_pls_inconsistencia_int.ds_complemento%type;
ds_complemento_w		w_pls_inconsistencia_int.ds_complemento%type;
vl_tot_pls_fatura_w		pls_fatura.vl_fatura%type;
nr_seq_conta_xml_w		pls_conta.nr_sequencia%type;
nr_seq_lote_fat_w		pls_lote_faturamento.nr_sequencia%type;
qt_conta_fora_xml_w		integer := 0;
vl_total_fat_xml		pls_fat_guia_envio_proc.vl_beneficiario%type;

-- Contas / Guias
C01 CURSOR( nr_seq_lote_fat_guia_pc 		pls_lote_fat_guia_envio.nr_sequencia%type ) FOR
	SELECT	x.ie_tipo_guia,
		z.nr_sequencia nr_seq_fat_guia_env,
		z.nr_seq_tipo_acomodacao,
		substr(obter_valor_dominio(1746, x.ie_tipo_guia), 1, 50) ds_tipo_guia,
		z.nr_seq_conta,
		z.nr_seq_clinica,
		z.nr_seq_grau_partic,
		z.nm_profissional_solic,
		z.dt_autorizacao,
		z.ie_tipo_atendimento,
		(SELECT	sum(coalesce(b.vl_beneficiario, 0))
		from	pls_fat_guia_envio_proc b
		where	b.nr_seq_guia_envio	= z.nr_sequencia) vl_tot_proc,
		(select	sum(coalesce(b.vl_beneficiario, 0))
		from	pls_fat_guia_envio_mat	b
		where	b.nr_seq_guia_envio	= z.nr_sequencia) vl_tot_mat
	from	pls_fat_guia_arquivo 	x,
		pls_fatura_guia_envio 	z
	where	x.nr_sequencia 		= z.nr_seq_guia_arquivo
	and	x.nr_seq_lote 		= nr_seq_lote_fat_guia_pc;

-- buscar as contas que entraram na fatura
	
c02 CURSOR FOR
	SELECT	distinct(b.nr_seq_conta)
	from	pls_fatura_conta	b,
		pls_fatura_evento	a
	where	a.nr_sequencia		= b.nr_seq_fatura_evento
	and	a.nr_seq_fatura		= nr_seq_fatura_p
	and not exists (
			SELECT	1
			from	pls_fat_guia_arquivo 	x,
				pls_fatura_guia_envio 	z
			where	x.nr_sequencia 		= z.nr_seq_guia_arquivo
			and	x.nr_seq_lote 		= nr_seq_lote_fat_guia_w
			and	z.nr_seq_conta		= b.nr_seq_conta)
	and exists (	select	1
			from	pls_lote_fat_guia_envio d
			where	d.nr_seq_fatura		= nr_seq_fatura_p);
	
BEGIN

select	count(1)
into STRICT	qt_regra_w
from	pls_regra_arquivo_fatura
where	ie_tipo_interface = 'O'
and	(nr_seq_esquema_xml IS NOT NULL AND nr_seq_esquema_xml::text <> '');

select	max(a.nr_seq_lote)
into STRICT	nr_seq_lote_fat_w
from	pls_fatura	a
where	a.nr_sequencia	= nr_seq_fatura_p;

if (qt_regra_w > 0) then
	SELECT * FROM pls_obter_caminho_arquivo_fat(	nr_seq_fatura_p, null, 'O', nm_usuario_p, ds_caminho_arquivo_w, ie_tipo_arquivo_w, cd_interface_w, ie_compactar_w, nr_seq_esquema_xml_w, nm_arquivo_w, nr_seq_regra_xml_w, ds_mascara_w, ds_mascara_zip_w, ds_interface_w, ie_tipo_compactar_w, ds_mascara_arq_adic_w) INTO STRICT ds_caminho_arquivo_w, ie_tipo_arquivo_w, cd_interface_w, ie_compactar_w, nr_seq_esquema_xml_w, nm_arquivo_w, nr_seq_regra_xml_w, ds_mascara_w, ds_mascara_zip_w, ds_interface_w, ie_tipo_compactar_w, ds_mascara_arq_adic_w;
end if;

if (nr_seq_esquema_xml_w = 101200) then
	ie_versao_xml_w := '2.02.03';
	
elsif (nr_seq_esquema_xml_w = 101252) then
	ie_versao_xml_w := '3.02.00';
	
elsif (coalesce(nr_seq_esquema_xml_w, 101499) = 101499) then
	ie_versao_xml_w := '3.02.01';
	
elsif (coalesce(nr_seq_esquema_xml_w, 101499) = 101810) then
	ie_versao_xml_w := '3.03.01';
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_lote_fat_guia_w
from	pls_lote_fat_guia_envio
where	nr_seq_fatura = nr_seq_fatura_p;

if (nr_seq_lote_fat_guia_w IS NOT NULL AND nr_seq_lote_fat_guia_w::text <> '') then
	select (select	coalesce(sum(b.vl_beneficiario),0)
		from	pls_fat_guia_envio_proc	b,
			pls_fatura_guia_envio	e,
			pls_fat_guia_arquivo	g
		where	b.nr_seq_guia_envio	= e.nr_sequencia
		and	e.nr_seq_guia_arquivo	= g.nr_sequencia
		and	g.nr_seq_lote		= a.nr_sequencia) +
		(select	coalesce(sum(b.vl_beneficiario),0)
		from	pls_fat_guia_envio_mat	b,	
			pls_fatura_guia_envio	e,
			pls_fat_guia_arquivo	g
		where	b.nr_seq_guia_envio	= e.nr_sequencia
		and	e.nr_seq_guia_arquivo	= g.nr_sequencia
		and	g.nr_seq_lote		= a.nr_sequencia)
	into STRICT	vl_total_fat_xml
	from	pls_lote_fat_guia_envio a
	where	a.nr_sequencia			= nr_seq_lote_fat_guia_w;
end if;

-- Obter valor total da fatura
select	coalesce(max(a.vl_fatura), 0) + coalesce(max(a.vl_total_ndc), 0)
into STRICT	vl_tot_pls_fatura_w
from	pls_fatura		a
where	a.nr_sequencia		= nr_seq_fatura_p;

-- Se o o valor do XML estiver diferente do valor total da Fatura
if (vl_total_fat_xml != vl_tot_pls_fatura_w ) then
	ds_complemento_w	:=	'Total fatura TASY: ' 	|| Campo_Mascara_virgula(vl_tot_pls_fatura_w) 	|| chr(10) ||
					'Total fatura XML: ' 	|| Campo_Mascara_virgula(vl_total_fat_xml) 	|| chr(10) ||
					'Fatura TASY: ' 	|| nr_seq_fatura_p				|| chr(10) ||
					'Fatura XML: ' 		|| nr_seq_lote_fat_guia_w;

	-- 183	Divergencia de Valor entre a Fatura e a Fatura XML		
	pls_inserir_incon_intercambio( 183, nr_seq_fatura_p, null, ds_complemento_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
	-- Divergencia de valor entre Fatura e Fatura XML
	CALL pls_gerar_ptu_lote_conta_erro(null, null, nm_usuario_p, cd_estabelecimento_p, nr_seq_fatura_p, null,nr_seq_lote_fat_w,183, 'TISS');
end if;

-- Contas / Guias
for r_C01_w in C01( nr_seq_lote_fat_guia_w ) loop
	vl_tot_conta_w := r_C01_w.vl_tot_proc + r_C01_w.vl_tot_mat;
	
	select	sum(coalesce(b.vl_faturado, 0)),
		sum(coalesce(b.vl_faturado_ndc, 0))
	into STRICT	vl_faturado_w,
		vl_faturado_ndc_w
	from	pls_fatura_conta	b,
		pls_fatura_evento	a
	where	a.nr_sequencia		= b.nr_seq_fatura_evento
	and	b.nr_seq_conta		= r_C01_w.nr_seq_conta
	and	a.nr_seq_fatura		= nr_seq_fatura_p;
	

	-- Se o valor for difente do valor do servico e diferente do valor de servico mais taxa, gera inconsistencia
	if (vl_tot_conta_w != vl_faturado_ndc_w) and (vl_tot_conta_w != (vl_faturado_w + vl_faturado_ndc_w)) then
		ds_conta_w := substr(ds_conta_w || ' /Conta: ' || r_C01_w.nr_seq_conta || ' ', 1, 4000);
	end if;
	
	
	if (ie_versao_xml_w = '2.02.03') then
		-- Guia de resumo de internacao
		if (r_C01_w.ie_tipo_guia = '5') then
			if (coalesce(r_c01_w.nr_seq_tipo_acomodacao::text, '') = '') then
				ds_complemento_w := 	'Tag: ANS:ACOMODACAO'				|| chr(10) ||
							'Fatura: '		|| nr_seq_fatura_p 	|| chr(10) ||
							'Conta: '		|| r_C01_w.nr_seq_conta || chr(10) ||
							'Guia: '		|| r_C01_w.ds_tipo_guia;
				
				-- 138 - Nao foi localizada informacao de acomodacao
				pls_inserir_incon_intercambio( 138, nr_seq_fatura_p, null, ds_complemento_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
			end if;
			
			if (coalesce(r_c01_w.nr_seq_clinica::text, '') = '') then
				ds_complemento_w := 	'Tag: ANS:TIPOINTERNACAO' 				|| chr(10) ||
							'Fatura: '			|| nr_seq_fatura_p 	|| chr(10) ||
							'Conta: '			|| r_C01_w.nr_seq_conta || chr(10) ||
							'Guia: '			|| r_C01_w.ds_tipo_guia;
				
				-- 139 - Nao foi localizada informacao de tipo de internacao
				pls_inserir_incon_intercambio( 139, nr_seq_fatura_p, null, ds_complemento_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
			end if;
		end if;
		
		-- Guia de honorario individual
		if (r_C01_w.ie_tipo_guia = '6') then
			if (coalesce(r_c01_w.nr_seq_grau_partic::text, '') = '') then
				ds_complemento_w := 	'Tag: ANS:POSICAOPROFISSIONAL'				|| chr(10) ||
							'Fatura: '			|| nr_seq_fatura_p 	|| chr(10) ||
							'Conta: '			|| r_C01_w.nr_seq_conta || chr(10) ||
							'Guia: '			|| r_C01_w.ds_tipo_guia;
							
				-- 140 - Nao foi localizada informacao de posicao profissional
				pls_inserir_incon_intercambio( 140, nr_seq_fatura_p, null, ds_complemento_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
			end if;
		end if;
		
		-- Guia de SP/SADT 
		if (r_C01_w.ie_tipo_guia = '4') then
			if (coalesce(r_c01_w.nm_profissional_solic::text, '') = '') then
				ds_complemento_w := 	'Tag: ANS:DADOSSOLICITANTE'				|| chr(10) ||
							'Fatura: '			|| nr_seq_fatura_p 	|| chr(10) ||
							'Conta: '			|| r_C01_w.nr_seq_conta || chr(10) ||
							'Guia: '			|| r_C01_w.ds_tipo_guia;
							
				-- 141 - Nao foi localizada informacao de profissional solicitante
				pls_inserir_incon_intercambio( 141, nr_seq_fatura_p, null, ds_complemento_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
			end if;
			
			if (coalesce(r_c01_w.ie_tipo_atendimento::text, '') = '') then
				ds_complemento_w := 	'Tag: ANS:TIPOATENDIMENTO'			|| chr(10) ||
							'Fatura: '		|| nr_seq_fatura_p 	|| chr(10) ||
							'Conta: '		|| r_C01_w.nr_seq_conta || chr(10) ||
							'Guia: '		|| r_C01_w.ds_tipo_guia;
							
				-- 143 - Nao foi localizada informacao de tipo de atendimento
				pls_inserir_incon_intercambio(143, nr_seq_fatura_p, null, ds_complemento_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
			end if;
		end if;
	elsif (ie_versao_xml_w = '3.02.00') then
		-- Guia de resumo de internacao
		if (r_C01_w.ie_tipo_guia = '5') then
			if (coalesce(r_c01_w.dt_autorizacao::text, '') = '') then
				ds_complemento_w := 	'Tag: ANS:DATAAUTORIZACAO'				|| chr(10) ||
							'Fatura: '			|| nr_seq_fatura_p 	|| chr(10) ||
							'Conta: '			|| r_C01_w.nr_seq_conta || chr(10) ||
							'Guia: '			|| r_C01_w.ds_tipo_guia;
							
				-- 142 - Nao foi localizada informacao de data de autorizacao
				pls_inserir_incon_intercambio(142, nr_seq_fatura_p, null, ds_complemento_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
			end if;
		end if;
	end if;
end loop;

-- select para verificar se tem conta que nao entrou na fatura XML
select	count(1)
into STRICT	qt_conta_fora_xml_w
from	pls_fatura_conta	b,
	pls_fatura_evento	a
where	a.nr_sequencia		= b.nr_seq_fatura_evento
and	a.nr_seq_fatura		= nr_seq_fatura_p
and not exists (
		SELECT	1
		from	pls_fat_guia_arquivo 	x,
			pls_fatura_guia_envio 	z
		where	x.nr_sequencia 		= z.nr_seq_guia_arquivo
		and	x.nr_seq_lote 		= nr_seq_lote_fat_guia_w
		and	z.nr_seq_conta		= b.nr_seq_conta)
and exists (	SELECT	1
		from	pls_lote_fat_guia_envio d
		where	d.nr_seq_fatura		= nr_seq_fatura_p);

if (qt_conta_fora_xml_w > 0) then

	ds_complemento_w	:=	'Fatura Tasy: '	|| nr_seq_fatura_p		|| chr(10) ||
					'Fatura XML: ' 	|| nr_seq_lote_fat_guia_w;
	for r_c02_w in c02 loop	
	
		ds_complemento_w := substr(ds_complemento_w || chr(10) || 'Conta: ' || r_c02_w.nr_seq_conta,1,4000);
		
		-- Conta nao entrou na Fatura XML
		CALL pls_gerar_ptu_lote_conta_erro(null, null, nm_usuario_p, cd_estabelecimento_p, nr_seq_fatura_p, r_c02_w.nr_seq_conta,nr_seq_lote_fat_w,182, 'TISS');
	end loop;
	
	-- 182	Conta nao entrou na Fatura XML
	pls_inserir_incon_intercambio( 182, nr_seq_fatura_p, null, ds_complemento_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
end if;

if ((trim(both ds_conta_w) IS NOT NULL AND (trim(both ds_conta_w))::text <> '')) then
	-- 175 - Valor de faturamento esta diferente do valor do arquivo XML
	pls_inserir_incon_intercambio(175, nr_seq_fatura_p, null, ds_conta_w, cd_estabelecimento_p, nm_usuario_p, ie_tipo_arquivo_p, null);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_dados_inter_tiss ( nr_seq_fatura_p pls_fatura.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_tipo_arquivo_p w_pls_inconsistencia_int.ie_tipo_arquivo%type ) FROM PUBLIC;
