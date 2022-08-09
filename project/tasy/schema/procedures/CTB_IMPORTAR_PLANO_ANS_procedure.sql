-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_importar_plano_ans ( nr_versao_p bigint, cd_empresa_p text, nm_usuario_p text) AS $body$
DECLARE


cd_conta_contabil_w		varchar(20);
ds_conta_contabil_w		varchar(255);
qt_registros_w			bigint	:= 0;
ds_retorno_w			varchar(4000);

c01 CURSOR FOR
SELECT	a.*
from	w_imp_conta_contabil a
order by a.nr_sequencia;

vet01	C01%RowType;

BEGIN

/*A consistência de obrigatoriedade dos campos e demais informacoes, ja é realizada
na rotina ctb_consistir_plano_importacao*/
open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

insert into ctb_plano_ans(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				cd_plano,
				cd_classificacao,
				ds_conta,
				ie_tipo,
				cd_empresa,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_versao_plano)
		values (	nextval('ctb_plano_ans_seq'),
				clock_timestamp(),
				nm_usuario_p,
				vet01.cd_plano,
				vet01.cd_classificacao,
				substr(vet01.ds_conta_contabil,1,255),
				vet01.ie_tipo,
				cd_empresa_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_versao_p);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_importar_plano_ans ( nr_versao_p bigint, cd_empresa_p text, nm_usuario_p text) FROM PUBLIC;
