-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ret_glosa_complexidade ( nm_usuario_p text, nr_sequencia_p bigint, ie_procedimento_p text, ie_honorario_p text, ie_taxa_p text, ie_diaria_p text, ie_material_p text, ie_medicamento_p text, ie_extra_p text, ie_complexidade_p text, ie_tipo_complex_p text) AS $body$
DECLARE

			 
			 
nr_seq_item_p	bigint;	
			 
C01 CURSOR FOR 
	SELECT	a.nr_sequencia 
	from	convenio_retorno_item a 
	where	a.nr_seq_retorno = nr_sequencia_p 
	order by a.nr_sequencia;			
 

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_item_p;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	 
	CALL gerar_retorno_glosa_conta_sus(nr_seq_item_p,nm_usuario_p,'G',1,ie_procedimento_p,ie_honorario_p,ie_taxa_p,ie_diaria_p,ie_material_p,ie_medicamento_p,ie_extra_p,ie_complexidade_p,'',ie_tipo_complex_p);
	end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ret_glosa_complexidade ( nm_usuario_p text, nr_sequencia_p bigint, ie_procedimento_p text, ie_honorario_p text, ie_taxa_p text, ie_diaria_p text, ie_material_p text, ie_medicamento_p text, ie_extra_p text, ie_complexidade_p text, ie_tipo_complex_p text) FROM PUBLIC;

