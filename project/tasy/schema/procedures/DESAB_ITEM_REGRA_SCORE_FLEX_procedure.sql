-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desab_item_regra_score_flex (( nr_sequencia_p bigint, nr_seq_escala_p bigint, nm_usuario_p text, ie_habilitado_p out text) is nr_seq_item_w bigint) AS $body$
DECLARE


		ie_item_sup_w	varchar(1) := 'N';
		ie_item_w		varchar(1) := 'N';
		nr_seq_sup_w	bigint;

		C01 CURSOR FOR
			SELECT	a.nr_seq_sup
			from	eif_escala_item_regra a
			where	nr_seq_item = nr_seq_item_p
			and		nr_seq_sup <> nr_seq_sup_p;

		
BEGIN
		open C01;
		loop
		fetch C01 into
			nr_seq_sup_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_item_sup_w
			from	escala_eif_item
			where	nr_seq_item = nr_seq_sup_w
			and		nr_seq_escala = nr_seq_escala_p
			and		ie_resultado = 'S'
			and		ie_habilitado = 'S';

			if (ie_item_sup_w = 'S') then
				ie_item_w := ie_item_sup_w;
			end if;

			end;
		end loop;
		close C01;

		return;

		end;


begin
begin
ie_habilitado_p := 'S';
  if (nr_seq_escala_p > 0) then
    CALL gerar_resultado_escala_eif(nr_seq_escala_p);
  end if;

select count(*)
into STRICT qt_regra_w
from eif_escala_item_regra;

if (coalesce(qt_regra_w,0) > 0) then

	if (coalesce(nr_sequencia_p,0) > 0) then

		select  max(nr_seq_item),
			max(ie_resultado),
			max(ie_habilitado)
		into STRICT	nr_seq_item_w,
			ie_resultado_w,
			ie_habilitado_w
		from 	escala_eif_item
		where 	nr_sequencia = nr_sequencia_p;

		if (ie_habilitado_w = 'N') then
			update  escala_eif_item
			set 	ie_resultado = 'N'
			where 	nr_sequencia = nr_sequencia_p;
			commit;
			ie_habilitado_p := ie_habilitado_w;
			goto final;
		end if;

		if (coalesce(nr_seq_item_w,0) > 0) then

			open C01;
			loop
			fetch C01 into
				nr_seq_item_dasabil_w,
				nr_seq_sup_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				if (ie_resultado_w = 'S') then
					update  escala_eif_item
					set 	ie_habilitado = 'N',
						ie_resultado = 'N'
					where   nr_seq_item = nr_seq_item_dasabil_w
					and	nr_seq_escala = nr_seq_escala_p;
				elsif (ie_resultado_w = 'N') then
					if (verifica_se_outro_sup(nr_seq_item_dasabil_w,nr_seq_sup_w) = 'N') then
						update  escala_eif_item
						set 	ie_habilitado = 'S'
						where   nr_seq_item = nr_seq_item_dasabil_w
						and	nr_seq_escala = nr_seq_escala_p;
					end if;
				end if;
				end;
			end loop;
			close C01;

		commit;
		end if;

	end if;
end if;

exception
when others then
    null;
end;

<<final>>
qt_reg_w		:= 0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desab_item_regra_score_flex (( nr_sequencia_p bigint, nr_seq_escala_p bigint, nm_usuario_p text, ie_habilitado_p out text) is nr_seq_item_w bigint) FROM PUBLIC;

