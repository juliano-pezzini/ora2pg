-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_rubrica_conta ( cd_empresa_p bigint, nr_seq_tipo_p bigint, cd_grupo_p bigint, cd_conta_contabil_p conta_contabil.cd_conta_contabil%type, ie_tipo_conta_p text, ie_origem_valor_p ctb_modelo_rubrica.ie_origem_valor%type, ie_negrito_p ctb_modelo_rubrica.ie_negrito%type, ie_italico_p ctb_modelo_rubrica.ie_italico%type, ie_sublinhado_p ctb_modelo_rubrica.ie_sublinhado%type, qt_desl_esq_p ctb_modelo_rubrica.qt_desl_esq%type, nm_usuario_p text) AS $body$
DECLARE


nr_seq_apres_w		ctb_modelo_rubrica.nr_seq_apres%type;
ds_conta_contabil_w	conta_contabil.ds_conta_contabil%type;
cd_conta_contabil_w	conta_contabil.cd_conta_contabil%type;
cd_grupo_w		ctb_grupo_conta.cd_grupo%type;
ie_negrito_w		ctb_modelo_rubrica.ie_negrito%type;
ie_italico_w		ctb_modelo_rubrica.ie_italico%type;
ie_sublinhado_w		ctb_modelo_rubrica.ie_sublinhado%type;
qt_desl_esq_w		ctb_modelo_rubrica.qt_desl_esq%type;
cd_classificacao_w	conta_contabil.cd_classificacao%type;

c01 CURSOR FOR
SELECT	a.cd_conta_contabil,
	a.ds_conta_contabil,
	substr(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, clock_timestamp()),1,40) cd_classificacao
from	conta_contabil	a
where	a.cd_empresa	= cd_empresa_p
and	a.ie_situacao	= 'A'
and	((a.cd_grupo	= cd_grupo_p) or (coalesce(cd_grupo_w::text, '') = ''))
and	((a.ie_tipo	= ie_tipo_conta_p) or (ie_tipo_conta_p = 'X'))
and	a.cd_conta_contabil	= coalesce(cd_conta_contabil_p, a.cd_conta_contabil)
order by cd_classificacao;


BEGIN

ie_negrito_w	:= coalesce(ie_negrito_p,'N');
ie_italico_w	:= coalesce(ie_italico_p,'N');
ie_sublinhado_w	:= coalesce(ie_sublinhado_p,'N');
qt_desl_esq_w	:= coalesce(qt_desl_esq_p,0);


select	coalesce(max(nr_seq_apres),0) + 1
into STRICT	nr_seq_apres_w
from	ctb_modelo_rubrica
where	nr_seq_modelo	= nr_seq_tipo_p;

cd_grupo_w	:= cd_grupo_p;
if (cd_grupo_w = 0) then
	cd_grupo_w	:= null;
end if;

open C01;
loop
fetch C01 into
	cd_conta_contabil_w,
	ds_conta_contabil_w,
	cd_classificacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	insert into ctb_modelo_rubrica(
		nr_sequencia,
		nr_seq_modelo,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		ds_rubrica, /* ds_conta_Contabil_w*/
		qt_desl_esq,
		ie_origem_valor,
		ds_origem,	/* cd_conta_contabil*/
		nr_seq_somat,
		ie_situacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_informacao,
		ds_divisor,
		ie_negrito,
		ie_italico,
		ie_sublinhado,
		ds_cor_fonte,
		ds_cor_fundo,
		ds_observacao,
		ie_tipo_ctb_estab,
		ie_grupo_balanco_ecd)
	values (	nextval('ctb_modelo_rubrica_seq'),
		nr_seq_tipo_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres_w,
		substr(ds_conta_contabil_w,1,80),
		qt_desl_esq_w,
		ie_origem_valor_p,
		cd_conta_contabil_w,
		0,
		'A',
		clock_timestamp(),
		nm_usuario_p,
		'A',
		null,
		ie_negrito_w,
		ie_italico_w,
		ie_sublinhado_w,
		null,
		null,
		null,
		null,
		null);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_rubrica_conta ( cd_empresa_p bigint, nr_seq_tipo_p bigint, cd_grupo_p bigint, cd_conta_contabil_p conta_contabil.cd_conta_contabil%type, ie_tipo_conta_p text, ie_origem_valor_p ctb_modelo_rubrica.ie_origem_valor%type, ie_negrito_p ctb_modelo_rubrica.ie_negrito%type, ie_italico_p ctb_modelo_rubrica.ie_italico%type, ie_sublinhado_p ctb_modelo_rubrica.ie_sublinhado%type, qt_desl_esq_p ctb_modelo_rubrica.qt_desl_esq%type, nm_usuario_p text) FROM PUBLIC;

