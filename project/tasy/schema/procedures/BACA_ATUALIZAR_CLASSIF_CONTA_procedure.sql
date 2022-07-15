-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_atualizar_classif_conta ( dt_vigencia_p timestamp) AS $body$
DECLARE



cd_conta_contabil_w		varchar(20);
cd_classif_superior_w		varchar(40);
cd_classificacao_w			varchar(40);
cd_empresa_w			bigint;
dt_inicio_vigencia_w		timestamp;
dt_vigencia_w			timestamp;
qt_registro_w			bigint;
ind				integer;
ds_erro_w			varchar(4000);

c01 CURSOR FOR
SELECT	a.cd_empresa,
	a.cd_conta_contabil,
	a.cd_classificacao,
	a.dt_inicio_vigencia
from	conta_contabil a;

type dados is table of C01%Rowtype index by integer;
vetor_w				dados;


BEGIN

dt_vigencia_w	:= coalesce(dt_vigencia_p, clock_timestamp());
ind		:= 0;

CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('N');

open C01;
loop
fetch C01 into
	cd_empresa_w,
	cd_conta_contabil_w,
	cd_classificacao_w,
	dt_inicio_vigencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ind	:= ind +1;
	vetor_w[ind].cd_empresa		:= cd_empresa_w;
	vetor_w[ind].cd_conta_contabil	:= cd_conta_contabil_w;
	vetor_w[ind].cd_classificacao		:= cd_classificacao_w;
	vetor_w[ind].dt_inicio_vigencia	:= dt_inicio_vigencia_w;

	end;
end loop;
close C01;

qt_registro_w	:= 0;
begin
for ind in 1..vetor_w.Count loop
	begin
	qt_registro_w		:= qt_registro_w + 1;
/*	dt_vigencia_w		:= nvl(vetor_w(ind).dt_inicio_vigencia, dt_vigencia_w);*/

	cd_classificacao_w		:= ctb_obter_classif_conta(vetor_w[ind].cd_conta_contabil, null, dt_vigencia_w);
	cd_classif_superior_w	:= substr(ctb_obter_classif_conta_sup(cd_classificacao_w, dt_vigencia_w, vetor_w[ind].cd_empresa),1,40);

	/*if (vetor_w(ind).cd_conta_contabil = '37121') then
		r.aise_application_error(-20011, 'cd_classif_w: '||cd_classificacao_w ||'dt vig:'||dt_vigencia_w);
	end if;*/
	update	conta_contabil
	set	cd_classificacao_atual	= cd_classificacao_w,
		cd_classif_superior_atual	= cd_classif_superior_w
	where	cd_conta_contabil		= vetor_w[ind].cd_conta_contabil;

	if (qt_registro_w >= 2000) then
		qt_registro_w	:= 0;
		commit;
	end if;

	end;
end loop;
exception when others then
	ds_erro_w := substr(sqlerrm(SQLSTATE),1,2000);
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(281059, 'DS_ERRO=' || ds_erro_w);
	CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('S');
end;

CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('S');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_atualizar_classif_conta ( dt_vigencia_p timestamp) FROM PUBLIC;

