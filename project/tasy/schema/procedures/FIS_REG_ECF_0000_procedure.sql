-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_reg_ecf_0000 ( nr_seq_controle_p text, ds_separador_p text, cd_estabelecimento_p text, nm_usuario_p text, cd_empresa_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_scp_p text) AS $body$
DECLARE


				
nr_seq_registro_w	bigint := nr_sequencia_p;	
nr_linha_w		bigint := qt_linha_p;
ds_arquivo_w		varchar(4000);	
ds_arquivo_compl_w	varchar(4000);	
ds_linha_w		varchar(4000);
sep_w			varchar(2) := 	ds_separador_p;
ie_inicio_periodo_w	bigint;
ie_situacao_especial_w	bigint;
dt_inicio_apuracao_w	timestamp;
dt_fim_apuracao_w	timestamp;
ie_tipo_ecf_w		bigint;
ie_retificadora_w	fis_controle_ecf.ie_retificadora%type;
cd_hash_ecf_anterior_w	fis_controle_ecf.cd_hash_ecf_anterior%type;
pr_pat_remanescente_w	fis_regra_ecf_0020.pr_pat_remanescente%type;	
dt_situacao_especial_w	fis_regra_ecf_0020.dt_situacao_especial%type;
cd_layout_w		varchar(4);
nr_seq_lote_w		fis_controle_ecf.nr_seq_lote%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;


C01 CURSOR FOR
	SELECT	'0000' tp_registro,
		substr(obter_dados_pf_pj(null, a.cd_cgc, 'N'),1,100) ds_fantasia,
		Elimina_Caracteres_Especiais(a.cd_cgc) cd_cnpj,
		'' cd_scp
	from	pessoa_juridica b,
		estabelecimento a
	where	a.cd_cgc = b.cd_cgc
	and	a.cd_estabelecimento = cd_estabelecimento_p
	and ie_scp_p = 'N'
	
union

	SELECT	'0000' tp_registro,
		substr(obter_dados_pf_pj(null, a.cd_cgc, 'N'),1,100) ds_fantasia,
		Elimina_Caracteres_Especiais(obter_cgc_estabelecimento(a.cd_estab_socio_ost_scp)) cd_cnpj,
		Elimina_Caracteres_Especiais(a.cd_cgc) cd_scp
	from	pessoa_juridica b,
		estabelecimento a
	where	a.cd_cgc = b.cd_cgc
	and	a.cd_estabelecimento = cd_estabelecimento_p
	and ie_scp_p = 'S';

vet01	C01%RowType;


BEGIN
	
select  max(dt_inicio_apuracao),
	max(dt_fim_apuracao),
	max(coalesce(ie_retificadora,'N')),
	max(cd_hash_ecf_anterior),
	max(nr_seq_lote)
into STRICT	dt_inicio_apuracao_w,
	dt_fim_apuracao_w,
	ie_retificadora_w,
	cd_hash_ecf_anterior_w,
	nr_seq_lote_w
from	fis_controle_ecf
where	nr_sequencia = nr_seq_controle_p;

select	max(ie_inicio_periodo),
	max(CASE WHEN ie_situacao_especial=10 THEN 0  ELSE ie_situacao_especial END ),
	max(CASE WHEN ie_tipo_ecf=10 THEN 0  ELSE ie_tipo_ecf END ),
	max(pr_pat_remanescente),
	max(dt_situacao_especial)
into STRICT	ie_inicio_periodo_w,
	ie_situacao_especial_w,
	ie_tipo_ecf_w,
	pr_pat_remanescente_w,
	dt_situacao_especial_w
from	fis_regra_ecf_0020
where	nr_seq_lote = nr_seq_lote_w
and	cd_empresa = cd_empresa_p;		

select  lpad(max(cd_ver), 4, '0')
into STRICT	cd_layout_w
from	fis_controle_ecf
where	nr_sequencia = nr_seq_controle_p;

open C01;
loop
fetch C01 into	
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	ds_linha_w :=  substr(sep_w || vet01.tp_registro 	|| -- Registro
			       sep_w || 'LECF'						|| -- Identificação do tipo sped (Escrituração contábil fiscal)
			       sep_w || cd_layout_w					|| -- Código da versão do layout
			       sep_w || vet01.cd_cnpj				|| -- CNPJ
			       sep_w || vet01.ds_fantasia			|| -- Nome da empresa
			       sep_w || ie_inicio_periodo_w			|| -- Indicador do Início do Período: 
			       sep_w || ie_situacao_especial_w			|| -- Situação Especial e Outros Eventos
			       sep_w || pr_pat_remanescente_w			|| -- Patrimônio Remanescente em Caso de Cisão
			       sep_w || to_char(dt_situacao_especial_w,'ddmmyyyy')	|| -- Data da Situação Especial ou Evento
			       sep_w || to_char(dt_inicio_apuracao_w,'ddmmyyyy')	|| -- Data do  Início do Período
			       sep_w || to_char(dt_fim_apuracao_w,'ddmmyyyy')	|| -- Data do Fim do Período: 
			       sep_w || ie_retificadora_w				|| -- Escrituração Retificadora
			       sep_w || cd_hash_ecf_anterior_w			|| -- Número do Recibo da ECF Anterior (hashcode)
			       sep_w || ie_tipo_ecf_w					|| -- Indicador do Tipo da ECF
			       sep_w || vet01.cd_scp					||sep_w,1,8000); -- Identificação da SCP
		
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w			:= nr_linha_w + 1;
	
	insert into fis_ecf_arquivo(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_controle_ecf,
		nr_linha,
		cd_registro,
		ds_arquivo,
		ds_arquivo_compl)
	values (	nr_seq_registro_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_controle_p,
		nr_linha_w,
		'0000',
		ds_arquivo_w,
		ds_arquivo_compl_w);
	
	end;
end loop;
close C01;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_reg_ecf_0000 ( nr_seq_controle_p text, ds_separador_p text, cd_estabelecimento_p text, nm_usuario_p text, cd_empresa_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_scp_p text) FROM PUBLIC;

