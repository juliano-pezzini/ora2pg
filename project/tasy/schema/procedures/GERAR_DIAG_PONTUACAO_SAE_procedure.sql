-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_diag_pontuacao_sae ( nr_sequencia_p bigint, nm_usuario_p text) is type Diag_Anteriores is record ( nr_seq_diag bigint, NR_SEQ_EVOLUCAO_DIAG bigint) RETURNS bigint AS $body$
BEGIN

	for i in 1..vt_diag_w.count loop
		begin

		if (vt_diag_w[i].nr_seq_diag	= nr_seq_diag_p) then
			return vt_diag_w[i].nr_seq_evolucao_diag;
		end if;

		end;
	end loop;
	return null;
	end;

begin
i := 1;
open C06;
loop
fetch C06 into
	c06_w;
EXIT WHEN NOT FOUND; /* apply on C06 */
	begin

	vt_diag_w[i].nr_seq_diag			:= c06_w.nr_seq_diag;
	vt_diag_w[i].nr_seq_evolucao_diag	:= c06_w.nr_seq_evolucao_diag;
	i	:= i+1;
	end;
end loop;
close C06;

delete 	from PE_PRESCR_DIAG
where	nr_seq_prescr	= nr_sequencia_p
and	coalesce(qt_pontuacao,-1)	<> -1;

select	max(ie_regra_diag_pont_sae)
into STRICT	ie_rotina_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (ie_rotina_w	= 'V') then
	open C03;
	loop
	fetch C03 into
		nr_seq_diag_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		delete	from PE_PRESCR_DIAG
		where	nr_seq_prescr	= nr_sequencia_p
		and	nr_seq_diag	= nr_seq_diag_w;
		end;
	end loop;
	close C03;

	commit;



	open C04;
	loop
	fetch C04 into
		qt_pontuacao_w,
		nr_seq_diag_assoc_w,
		nr_seq_tipo_item_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		RAISE NOTICE 'qt_pontuacao_w = %', qt_pontuacao_w;
		RAISE NOTICE 'nr_seq_item_w = %', nr_seq_item_w;
		RAISE NOTICE 'nr_seq_diag_assoc_w = %', nr_seq_diag_assoc_w;
		/*
		select	 max(nr_seq_tipo_item)
		into	 nr_seq_tipo_item_w
		from	 pe_item_tipo_item
		where	 nr_seq_item = nr_seq_item_w;
		*/
		open C05;
		loop
		fetch C05 into
			nr_seq_diag_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			NR_SEQ_EVOLUCAO_DIAG_w	:= buscarEvolDiag(nr_seq_diag_w);
			CALL Gerar_diag_enfermagem(nr_sequencia_p,nr_seq_diag_w,nm_usuario_p,qt_pontuacao_w,NR_SEQ_EVOLUCAO_DIAG_w);
			end;
		end loop;
		close C05;

		end;
	end loop;
	close C04;
	commit;
else
	open C01;
	loop
	fetch C01 into
		qt_pontuacao_w,
		nr_seq_tipo_item_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		RAISE NOTICE 'qt_pontuacao_w = %', qt_pontuacao_w;
		RAISE NOTICE 'nr_seq_tipo_item_w = %', nr_seq_tipo_item_w;
		open C03;
		loop
		fetch C03 into
			nr_seq_diag_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			delete	from PE_PRESCR_DIAG
			where	nr_seq_prescr	= nr_sequencia_p
			and	nr_seq_diag	= nr_seq_diag_w;
			end;
		end loop;
		close C03;


		open C02;
		loop
		fetch C02 into
			nr_seq_diag_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			NR_SEQ_EVOLUCAO_DIAG_w	:= buscarEvolDiag(nr_seq_diag_w);
			CALL Gerar_diag_enfermagem(nr_sequencia_p,nr_seq_diag_w,nm_usuario_p,qt_pontuacao_w,NR_SEQ_EVOLUCAO_DIAG_w);
			end;
		end loop;
		close C02;

		end;
	end loop;
	close C01;

	commit;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_diag_pontuacao_sae ( nr_sequencia_p bigint, nm_usuario_p text) is type Diag_Anteriores is record ( nr_seq_diag bigint, NR_SEQ_EVOLUCAO_DIAG bigint) FROM PUBLIC;

