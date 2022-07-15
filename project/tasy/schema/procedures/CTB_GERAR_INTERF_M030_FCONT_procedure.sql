-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_interf_m030_fcont ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
	IE_PERIODO_W
		A - Anual
		T - Trimestral
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_linha_w			varchar(8000);
ds_arquivo_w			varchar(4000);
ds_compl_arquivo_w		varchar(4000);
tp_registro_w			varchar(15);
sep_w				varchar(1)	:= '|';
ie_debito_credito_w		varchar(1)	:= 'C';
nr_linha_w			bigint	:= qt_linha_p;
nr_seq_registro_w		bigint	:= nr_sequencia_p;
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
dt_referencia_w			timestamp;
cd_conta_result_w		ctb_regra_sped.cd_conta_result%type;
vl_saldo_w			ctb_saldo.vl_saldo%type;
ie_periodo_w			ctb_regra_sped.ie_periodo%type;
ie_consolida_empresa_w		ctb_regra_sped.ie_consolida_empresa%type;

c_saldo CURSOR FOR
	SELECT	b.dt_referencia,
		'A00' ie_periodo,
		coalesce(sum(a.vl_saldo),0) vl_saldo
	from	ctb_mes_ref	b,
		ctb_saldo	a
	where	b.nr_sequencia		= a.nr_seq_mes_ref
	and	b.dt_referencia		= dt_fim_w
	and	b.cd_empresa		= cd_empresa_p
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.cd_conta_contabil	= cd_conta_result_w
	and	ie_periodo_w		= 'A'
	and	ie_consolida_empresa_w	= 'N'
	group by
		b.dt_referencia
	
union

	SELECT	b.dt_referencia,
		'A00' ie_periodo,
		coalesce(sum(a.vl_saldo),0) vl_saldo
	from	estabelecimento	c,
		ctb_mes_ref	b,
		ctb_saldo	a
	where	b.nr_sequencia			= a.nr_seq_mes_ref
	and	c.cd_estabelecimento		= a.cd_estabelecimento
	and	coalesce(c.ie_gerar_sped,'S')	= 'S'
	and	b.dt_referencia			= dt_fim_w
	and	b.cd_empresa			= cd_empresa_p
	and	a.cd_conta_contabil		= cd_conta_result_w
	and	ie_periodo_w			= 'A'
	and	ie_consolida_empresa_w		= 'S'
	group by
		b.dt_referencia
	
union

	select	b.dt_referencia,
		substr('T' || substr(obter_periodo_data(b.dt_referencia,'T'),1,2),1,3) ie_periodo,
		coalesce(sum(a.vl_saldo),0) vl_saldo
	from	ctb_mes_ref b,
		ctb_saldo a
	where	b.nr_sequencia		= a.nr_seq_mes_ref
	and	substr(to_char(b.dt_referencia,'mm'),1,2) in ('03','06','09','12')
	and	b.cd_empresa		= cd_empresa_p
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.cd_conta_contabil	= cd_conta_result_w
	and	ie_periodo_w		= 'T'
	and	ie_consolida_empresa_w	= 'N'
	and	b.dt_referencia	between  dt_inicio_w and dt_fim_w
	group by
		b.dt_referencia
	
union

	select	b.dt_referencia,
		substr('T' || substr(obter_periodo_data(b.dt_referencia,'T'),1,2),1,3) ie_periodo,
		coalesce(sum(a.vl_saldo),0) vl_saldo
	from	estabelecimento	c,
		ctb_mes_ref	b,
		ctb_saldo	a
	where	b.nr_sequencia			= a.nr_seq_mes_ref
	and	c.cd_estabelecimento		= a.cd_estabelecimento
	and	coalesce(c.ie_gerar_sped,'S')	= 'S'
	and	substr(to_char(b.dt_referencia,'mm'),1,2) in ('03','06','09','12')
	and	b.cd_empresa			= cd_empresa_p
	and	a.cd_conta_contabil		= cd_conta_result_w
	and	ie_periodo_w			= 'T'
	and	ie_consolida_empresa_w		= 'S'
	and	b.dt_referencia	between dt_inicio_w and dt_fim_w
	group by
		b.dt_referencia
	order by
		dt_referencia;


BEGIN
dt_inicio_w	:= trunc(dt_inicio_p, 'mm');
dt_fim_w	:= trunc(dt_fim_p, 'mm');

select	max(a.cd_conta_result),
	max(a.ie_periodo),
	max(a.ie_consolida_empresa)
into STRICT	cd_conta_result_w,
	ie_periodo_w,
	ie_consolida_empresa_w
from	ctb_regra_sped		a,
	ctb_sped_controle	b
where	a.nr_sequencia	= b.nr_seq_regra_sped
and	b.nr_sequencia	= nr_seq_controle_p;

ie_periodo_w		:= coalesce(ie_periodo_w, 'A');
ie_consolida_empresa_w	:= coalesce(ie_consolida_empresa_w, 'N');

tp_registro_w	:= 'M030';

open c_saldo;
loop
fetch c_saldo into
	dt_referencia_w,
	ie_periodo_w,
	vl_saldo_w;
EXIT WHEN NOT FOUND; /* apply on c_saldo */
	begin
	if (vl_saldo_w < 0) then
		ie_debito_credito_w	:= 'D';
	end if;

	ds_linha_w	:= substr(	sep_w || tp_registro_w 				||
					sep_w || ie_periodo_w 				||
					sep_w || sped_obter_campo_valor(vl_saldo_w)	||
					sep_w || ie_debito_credito_w			||
					sep_w,1,8000);

	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	insert into ctb_sped_registro(nr_sequencia,
		ds_arquivo,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_controle_sped,
		ds_arquivo_compl,
		cd_registro,
		nr_linha)
	values (nr_seq_registro_w,
		ds_arquivo_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		ds_compl_arquivo_w,
		tp_registro_w,
		nr_linha_w);

	end;
end loop;
close c_saldo;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_interf_m030_fcont ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

