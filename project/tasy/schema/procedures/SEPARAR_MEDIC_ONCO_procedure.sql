-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE separar_medic_onco ( nr_seq_ordem_p bigint, nm_usuario_p text, ie_acao_p text) AS $body$
DECLARE



nr_sequencia_w		w_separacao_quimio.nr_sequencia%type;
nr_seq_ordem_w		w_separacao_quimio.nr_seq_ordem%type;
cd_material_w		w_separacao_quimio.cd_material%type;
cd_unidade_medida_w	w_separacao_quimio.cd_unidade_medida%type;
qt_dose_w		w_separacao_quimio.qt_dose%type;


/* 	IE_TIPO_ITEM
	M - medicamento
	P - Material da prescricao
	N - Não previsto		*/
C01 CURSOR FOR
	SELECT 	a.cd_material,
		a.cd_unidade_medida,
		a.qt_dose,
		a.nr_seq_ordem
	from 	can_ordem_item_prescr a
	where 	a.nr_seq_ordem = nr_seq_ordem_p;

BEGIN

if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') then

	if (coalesce(ie_acao_p,'C') = 'R') then

	    update can_ordem_prod
	    set	dt_inicio_separacao = clock_timestamp(),
		nm_usuario_separacao = nm_usuario_p
	    where nr_sequencia 	     = nr_seq_ordem_p;


	    open C01;
		loop
		fetch C01 into
			cd_material_w,
			cd_unidade_medida_w,
			qt_dose_w,
			nr_seq_ordem_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then

			   insert into w_separacao_quimio(
				nr_sequencia,
				nr_seq_ordem,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				ie_tipo_item,
				cd_material,
				cd_unidade_medida,
				qt_dose)
			   values (nextval('w_separacao_quimio_seq'),
				nr_seq_ordem_w,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				'M',
				cd_material_w,
				cd_unidade_medida_w,
				qt_dose_w);

				commit;

			end if;
			end;

		end loop;
		close C01;

	elsif (coalesce(ie_acao_p,'C') = 'C') then

	    update can_ordem_prod
	    set	dt_inicio_separacao  = NULL,
		nm_usuario_separacao  = NULL
	    where nr_sequencia = nr_seq_ordem_p;

	    delete from w_separacao_quimio
	    where nm_usuario 	= nm_usuario_p;

	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE separar_medic_onco ( nr_seq_ordem_p bigint, nm_usuario_p text, ie_acao_p text) FROM PUBLIC;

