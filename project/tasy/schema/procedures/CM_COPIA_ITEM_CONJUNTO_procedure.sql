-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_copia_item_conjunto ( nr_seq_item_p bigint, nr_seq_conjunto_p bigint, nr_seq_conj_dest_p bigint, qt_item_p bigint, ie_indispensavel_p text, qt_copias_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nm_item_w		varchar(255);
ie_situacao_w		varchar(1);
nr_seq_classif_w		bigint;
ds_item_w		varchar(2000);
cd_material_w		integer;
dt_revisao_w		timestamp;
ds_observacao_w		varchar(255);
ds_reduzida_w		varchar(20);
cd_medico_w		varchar(10);
ie_descartavel_w		varchar(1);
ie_controle_cavidade_w	varchar(1);
ie_tamanho_w		varchar(15);
cd_codigo_w		cm_item.cd_codigo%type;

ie_existe_anexo_w		varchar(1);
ie_existe_apelido_w	varchar(1);
ie_existe_fabricante_w	varchar(1);

nr_sequencia_w		bigint;
qt_copias_feitas_w	bigint;
qt_copias_w		bigint;

nr_seq_anexo_w		bigint;
ds_arquivo_w		varchar(255);

nr_seq_apelido_w		bigint;
ds_apelido_w		varchar(255);

nr_seq_fabricante_w	bigint;
cd_referencia_w		varchar(20);

ie_forma_gerar_cod_w	varchar(15);
cd_codigo_item_w		varchar(255);

ie_indispensavel_w		varchar(1);
nr_seq_interno_w		bigint;
qt_item_w		double precision;
nr_seq_conj_dest_w	bigint;
ie_unico_w		cm_item.ie_unico%type;


c01 CURSOR FOR
SELECT	ds_arquivo
from	cm_item_anexo
where	nr_seq_item = nr_seq_item_p;

c02 CURSOR FOR
SELECT	ds_apelido
from	cm_item_apelido
where	nr_seq_item = nr_seq_item_p;

c03 CURSOR FOR
SELECT	nr_seq_fabricante,
	cd_referencia
from	cm_item_fabric
where	nr_seq_item = nr_seq_item_p;


BEGIN
/* Definir conjunto destino do item, caso esteja sendo duplicado algum conjunto */

nr_seq_conj_dest_w	:= coalesce(nr_seq_conj_dest_p,nr_seq_conjunto_p);

/* Identificar forma de gerar o cod. externo */

ie_forma_gerar_cod_w := obter_valor_param_usuario(406, 61, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);

/* Buscar dados do cadastro do item para efetuar a copia do cadastro*/

select	nm_item,
	ie_situacao,
	nr_seq_classif,
	ds_item,
	cd_material,
	dt_revisao,
	ds_observacao,
	ds_reduzida,
	cd_medico,
	ie_descartavel,
	ie_controle_cavidade,
	ie_tamanho,
	cd_codigo,
	ie_unico
into STRICT	nm_item_w,
	ie_situacao_w,
	nr_seq_classif_w,
	ds_item_w,
	cd_material_w,
	dt_revisao_w,
	ds_observacao_w,
	ds_reduzida_w,
	cd_medico_w,
	ie_descartavel_w,
	ie_controle_cavidade_w,
	ie_tamanho_w,
	cd_codigo_w,
	ie_unico_w
from	cm_item
where	nr_sequencia = nr_seq_item_p;

/* Identificar se existe anexo no item */

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_existe_anexo_w
from	cm_item_anexo
where	nr_seq_item = nr_seq_item_p;

/* Identificar se existe apelido para o item */

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_existe_apelido_w
from	cm_item_apelido
where	nr_seq_item = nr_seq_item_p;

/* Identificar se ha registro de fabricantes para o item */

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_existe_fabricante_w
from	cm_item_fabric
where	nr_seq_item = nr_seq_item_p;

qt_copias_w		:= coalesce(qt_copias_p,1);
qt_copias_feitas_w	:= 0;

/* Inicia processo de copia do item, o qual continua ate a qtde. atingir o total solicitado */

while(qt_copias_feitas_w < qt_copias_w) loop
	begin

	select	nextval('cm_item_seq')
	into STRICT	nr_sequencia_w
	;

	insert into cm_item(
		nr_sequencia,
		nm_item,
		dt_atualizacao,
		nm_usuario,
		ie_situacao,
		nr_seq_classif,
		ds_item,
		cd_material,
		dt_revisao,
		ds_observacao,
		ds_reduzida,
		cd_medico,
		ie_descartavel,
		ie_controle_cavidade,
		ie_tamanho,
		cd_codigo,
		ie_unico)
	values (nr_sequencia_w,
		nm_item_w,
		clock_timestamp(),
		nm_usuario_p,
		ie_situacao_w,
		nr_seq_classif_w,
		ds_item_w,
		cd_material_w,
		dt_revisao_w,
		ds_observacao_w,
		ds_reduzida_w,
		cd_medico_w,
		ie_descartavel_w,
		ie_controle_cavidade_w,
		ie_tamanho_w,
		cd_codigo_w,
		ie_unico_w);

	if (ie_existe_anexo_w = 'S') then
		begin

		open c01;
		loop
		fetch c01 into
			ds_arquivo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			select	nextval('cm_item_anexo_seq')
			into STRICT	nr_seq_anexo_w
			;

			insert into cm_item_anexo(
				nr_sequencia,
				ds_arquivo,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_item) values (
					nr_seq_anexo_w,
					ds_arquivo_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_sequencia_w);

			end;
		end loop;
		close c01;

		end;
	end if;

	if (ie_existe_apelido_w = 'S') then
		begin

		open c02;
		loop
		fetch c02 into
			ds_apelido_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			select	nextval('cm_item_apelido_seq')
			into STRICT	nr_seq_apelido_w
			;

			insert into cm_item_apelido(
				nr_sequencia,
				nr_seq_item,
				ds_apelido,
				dt_atualizacao,
				nm_usuario) values (
					nr_seq_apelido_w,
					nr_sequencia_w,
					ds_apelido_w,
					clock_timestamp(),
					nm_usuario_p);

			end;
		end loop;
		close c02;

		end;
	end if;

	if (ie_existe_fabricante_w = 'S') then
		begin

		open c03;
		loop
		fetch c03 into
			nr_seq_fabricante_w,
			cd_referencia_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin

			insert into cm_item_fabric(
				nr_seq_item,
				nr_seq_fabricante,
				dt_atualizacao,
				nm_usuario,
				cd_referencia) values (
					nr_sequencia_w,
					nr_seq_fabricante_w,
					clock_timestamp(),
					nm_usuario_p,
					cd_referencia_w);

			end;
		end loop;
		close c03;

		end;
	end if;

	select	coalesce(max(nr_seq_interno),0) + 1
	into STRICT	nr_seq_interno_w
	from	cm_conjunto_item
	where	nr_seq_conjunto = nr_seq_conj_dest_w;

	cd_codigo_item_w := cm_gerar_codigo_item_conj(nr_seq_conj_dest_w, cd_estabelecimento_p, nr_seq_interno_w, ie_forma_gerar_cod_w, nm_usuario_p, cd_codigo_item_w);

	/* Vincula o novo item no conjunto */
	
	insert into CM_CONJUNTO_ITEM(
		nr_seq_conjunto,
		nr_seq_item,
		qt_item,
		dt_atualizacao,
		nm_usuario,
		cd_codigo,
		ie_indispensavel,
		nr_seq_interno,
		ie_status_item) values (
				nr_seq_conj_dest_w,
				nr_sequencia_w,
				qt_item_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_codigo_item_w,
				ie_indispensavel_p,
				nr_seq_interno_w,
				'1');

	qt_copias_feitas_w	:= (qt_copias_feitas_w + 1);

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_copia_item_conjunto ( nr_seq_item_p bigint, nr_seq_conjunto_p bigint, nr_seq_conj_dest_p bigint, qt_item_p bigint, ie_indispensavel_p text, qt_copias_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

