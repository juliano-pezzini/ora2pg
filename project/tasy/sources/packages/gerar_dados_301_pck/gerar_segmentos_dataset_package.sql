-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	--Busca todos os segmentos do dataset conforme layout
	-- e chama as procedures individuais de geração de cada segmento
CREATE OR REPLACE PROCEDURE gerar_dados_301_pck.gerar_segmentos_dataset (ie_dataset_p text, nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


	ie_segmento_w	c301_estrutura_seg_dataset.ie_segmento%type;
	ds_parametros_w	varchar(2000);
	nm_procedure_w	varchar(255);
	ds_separador_w	varchar(10) := ';';

	c01 CURSOR FOR
	SELECT	a.ie_segmento
	from	c301_estrutura_seg_dataset a
	where	a.nr_seq_estrut_arq	= nr_seq_estrut_arq_w
	and	a.ie_dataset		= ie_dataset_p
	order by nr_ordem;

	
BEGIN

	ds_parametros_w	:= 	'nr_seq_dataset=' || nr_seq_dataset_p || ds_separador_w ||
				'nm_usuario='|| nm_usuario_p || ds_separador_w;

	open C01;
	loop
	fetch C01 into
		ie_segmento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		begin
			select	object_name
			into STRICT	nm_procedure_w
			from	user_objects
			where	object_name	= 'GERAR_D301_SEGMENTO_'|| ie_segmento_w;
		exception
		when others then
			nm_procedure_w := null;
		end;

		if (nm_procedure_w IS NOT NULL AND nm_procedure_w::text <> '') then
			CALL exec_sql_dinamico_bv('Tasy','begin '|| nm_procedure_w ||'(:nr_seq_dataset,:nm_usuario); end;', ds_parametros_w );
		end if;

	end loop;
	close C01;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_301_pck.gerar_segmentos_dataset (ie_dataset_p text, nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;