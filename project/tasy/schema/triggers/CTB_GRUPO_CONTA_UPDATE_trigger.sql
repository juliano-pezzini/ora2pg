-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_grupo_conta_update ON ctb_grupo_conta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_grupo_conta_update() RETURNS trigger AS $BODY$
declare
ie_sistema_ctb_w		varchar(01);
cd_conta_contabil_w	varchar(40);
ds_conta_contabil_w	varchar(255);
cd_classificacao_w		varchar(40);
cd_classif_w		varchar(40);
ds_mascara_w		varchar(40);
vl_nivel_w		varchar(15);
vl_nivel_ww		varchar(15);

type campos is record(
	qt_digito_old	integer,
	qt_digito_new	integer);
type Vetor is table of campos index by integer;
Mascara_w		Vetor;
i			integer;
k			integer;
z			integer;

C01 CURSOR FOR
	SELECT	cd_conta_contabil,
		cd_classificacao,
		ds_conta_contabil
	from	conta_contabil
	where	cd_grupo	= NEW.cd_grupo
	  and	length(cd_classificacao) >= k
	  and	length(cd_classificacao) <= k + Mascara_w[i].qt_digito_old
	order by cd_classificacao;

BEGIN
select	ie_sistema_ctb
into STRICT	ie_sistema_ctb_w
from	empresa
where	cd_empresa	= NEW.cd_empresa;
if (NEW.cd_mascara <> OLD.cd_mascara) and (ie_sistema_ctb_w = 'S') then
	BEGIN
	ds_mascara_w	:= OLD.cd_mascara;
	i	:= 0;
	while	ds_mascara_w is not null LOOP
		BEGIN
		select position('.' in ds_mascara_w) into STRICT k;
		if (k > 0) then
			i := I + 1;
			Mascara_w[i].qt_digito_old := k - 1;
			ds_mascara_w	:= substr(ds_mascara_w, k + 1, 20);
		else
			i := I + 1;
			Mascara_w[i].qt_digito_old := length(ds_mascara_w);
			ds_mascara_w	:= null;
		end if;
		end;
	END LOOP;
	ds_mascara_w	:= NEW.cd_mascara;
	i	:= 0;
	while	ds_mascara_w is not null LOOP
		BEGIN
		select position('.' in ds_mascara_w) into STRICT k;
		if (k > 0) then
			i := I + 1;
			Mascara_w[i].qt_digito_new := k - 1;
			ds_mascara_w	:= substr(ds_mascara_w, k + 1, 20);
		else
			i := I + 1;
			Mascara_w[i].qt_digito_new := length(ds_mascara_w);
			ds_mascara_w	:= null;
		end if;
		end;
	END LOOP;
	K	:= 0;
	FOR i in 1..Mascara_w.count LOOP
		BEGIN
		k	:= k + 1;
		if (mascara_w[i].qt_digito_new < mascara_w[i].qt_digito_old) then
			BEGIN
			vl_nivel_ww	:= '';
			FOR y in 1 .. mascara_w[i].qt_digito_new LOOP
				vl_nivel_ww := vl_nivel_ww || '9';
			END LOOP;
/* Consistir se existe conta com valor no nivel maior que os digitos do nivel (1.2.12/1.2.3) */

			OPEN  C01;
			LOOP
			FETCH C01 into	cd_conta_contabil_w,
					cd_classificacao_w,
					ds_conta_contabil_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				vl_nivel_w	:= substr(cd_classificacao_w, k,
						mascara_w[i].qt_digito_old);
				if (vl_nivel_w > vl_nivel_ww) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(266453,
						'CD_CONTA_CONTABIL_W=' || cd_conta_contabil_w	|| ';' ||
						'DS_CONTA_CONTABIL_W=' || ds_conta_contabil_w 	|| ';' ||
						'CD_CLASSIFICACAO_W='  || cd_classificacao_w);
				end if;
			END LOOP;
			CLOSE C01;
			OPEN  C01;
			LOOP
			FETCH C01 into	cd_conta_contabil_w,
					cd_classificacao_w,
					ds_conta_contabil_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				z	:= k + 1 + mascara_w[i].qt_digito_old - mascara_w[i].qt_digito_new;
				cd_classif_w	:= substr(cd_classificacao_w,1,k) ||
						substr(cd_classificacao_w, z, 20);
				update	conta_contabil
				set 	cd_classificacao	= cd_classif_w
				where	cd_conta_contabil	= cd_conta_contabil_w;
			END LOOP;
			CLOSE C01;
			end;
		end if;
		if (mascara_w[i].qt_digito_new > mascara_w[i].qt_digito_old) then
			BEGIN
			vl_nivel_ww	:= '';
			FOR y in mascara_w[i].qt_digito_old + 1 .. mascara_w[i].qt_digito_new LOOP
				vl_nivel_ww := vl_nivel_ww || '0';
			END LOOP;
			OPEN  C01;
			LOOP
			FETCH C01 into	cd_conta_contabil_w,
					cd_classificacao_w,
					ds_conta_contabil_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				cd_classif_w	:= substr(cd_classificacao_w,1,k) || vl_nivel_ww ||
					substr(cd_classificacao_w, k + 1, mascara_w[i].qt_digito_old);
				update	conta_contabil
				set 	cd_classificacao	= cd_classif_w
				where	cd_conta_contabil	= cd_conta_contabil_w;
			END LOOP;
			CLOSE C01;
			end;
		end if;
		k	:= k + mascara_w[i].qt_digito_new;
		end;
	END LOOP;

	end;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_grupo_conta_update() FROM PUBLIC;

CREATE TRIGGER ctb_grupo_conta_update
	BEFORE UPDATE ON ctb_grupo_conta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_grupo_conta_update();

