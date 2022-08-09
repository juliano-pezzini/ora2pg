-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_regulacao_item ( nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_sequencia_regra_p bigint, ie_tipo_p text, ie_apresentar_p INOUT text) AS $body$
DECLARE



customSQL_w			varchar(4000);
nr_seq_exame_w		bigint;
nr_seq_exame_lab_w 	bigint;
cd_material_exame_w	varchar(20);
cd_procedimento_w	bigint;
nr_seq_proc_int_sus_w 	bigint;
ie_origem_proced_w	bigint;

ie_exige_justi_w	varchar(1);
nr_seq_aval_w		bigint;
ds_mensagem_w		varchar(255);
nr_seq_item_pos_w	bigint;
ds_sql_w			varchar(4000);
ds_titulo_w			varchar(150);
ds_documentacao_w	varchar(255);
ie_resultado_w		varchar(80);
nr_seq_regulacao_w	bigint;

nr_seq_consistencia_w	bigint;

C01 CURSOR FOR
		SELECT	max(a.nr_seq_exame),			
				max(a.nr_seq_exame_lab),
				max(a.cd_material_exame),
				max(a.cd_procedimento),
				max(coalesce(a.nr_seq_proc_int_sus,a.nr_proc_interno)),
				max(a.ie_origem_proced)
		from	pedido_exame_externo_item a,
				pedido_exame_externo b
		where	b.nr_sequencia = a.nr_seq_pedido
		and		b.nr_sequencia = nr_sequencia_regra_p;

			

BEGIN

Delete from consist_regulacao_itens
where   nm_usuario = nm_usuario_p
and		nr_atendimento = nr_atendimento_p;

commit;

if (ie_tipo_p = 'SE') then

	ie_apresentar_p := 'N';

	open C01;
	loop
	fetch C01 into	
		nr_seq_exame_w,		
		nr_seq_exame_lab_w, 		
		cd_material_exame_w,	
		cd_procedimento_w,	
		nr_seq_proc_int_sus_w,
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			SELECT * FROM obter_regras_regulacao_exame(nr_seq_exame_w, nr_seq_exame_lab_w, nr_seq_proc_int_sus_w, cd_procedimento_w, ie_origem_proced_w, cd_material_exame_w, nr_atendimento_p, ie_exige_justi_w, nr_seq_aval_w, ds_mensagem_w, nr_seq_item_pos_w, ds_sql_w, ds_titulo_w, ds_documentacao_w) INTO STRICT ie_exige_justi_w, nr_seq_aval_w, ds_mensagem_w, nr_seq_item_pos_w, ds_sql_w, ds_titulo_w, ds_documentacao_w;
			
				customSQL_w :=  ' select nvl(max(''S''), ''N'') ' ||
						  ' from  pessoa_fisica a'     ||
						  ' where  a.cd_pessoa_fisica = :cd_pessoa_fisica  '   ||
						ds_sql_w;

				EXECUTE customSQL_w
				into STRICT   ie_resultado_w
				using  cd_pessoa_fisica_p;
				
				if (ie_resultado_w = 'N') then
					
					ie_apresentar_p := 'S';
					
					insert into consist_regulacao_itens(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario_nrec,
						nm_usuario,
						nr_atendimento,
						nr_seq_origem,	
						ds_inconsistencia,	
						ds_documentacao)		
					values (
						nextval('consist_regulacao_itens_seq'),
						clock_timestamp(), 
						nm_usuario_p,
						nm_usuario_p,
						nr_atendimento_p,
						nr_sequencia_regra_p,
						coalesce(ds_titulo_w,' '),
						ds_documentacao_w);
				end if;
		end;
	end loop;
	close C01;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_regulacao_item ( nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_sequencia_regra_p bigint, ie_tipo_p text, ie_apresentar_p INOUT text) FROM PUBLIC;
