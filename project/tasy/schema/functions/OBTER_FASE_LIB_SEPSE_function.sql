-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_fase_lib_sepse (nr_seq_escala_p bigint) RETURNS bigint AS $body$
DECLARE


qt_reg_w			bigint;
qt_var_w			bigint;
qt_susp_w			bigint;
qt_grave_w			bigint;
qt_geral_w			bigint;
ie_retorno_w		smallint := 0;
ie_tipo_evolucao_w	varchar(3);
ie_pessoa_destino_w	varchar(15);
nr_seq_mentor_w		bigint;
ie_regra_sepse_w	varchar(3);
ie_versao_sepse_w   varchar(10);

C01 CURSOR FOR
	SELECT	nr_sequencia,
			qt_var_suspeita,
			qt_var_confirmada,
			ie_regra_sepse
	from	gqa_pendencia_regra b
	where	b.nr_seq_escala = 124
	and		ie_situacao = 'A';

C02 CURSOR FOR
	SELECT	ie_pessoa_destino
	from	gqa_pendencia_regra a,
			gqa_acao b,
			gqa_acao_regra_prof c
	where	a.nr_sequencia = b.nr_seq_pend_regra
	and		b.nr_sequencia = c.nr_seq_acao
	and		a.nr_sequencia = nr_seq_mentor_w;


BEGIN

select	count(*)
into STRICT	qt_reg_w
from	escala_sepse_item
where	nr_seq_escala = nr_seq_escala_p;

if (qt_reg_w > 0) then

	select coalesce(ie_versao_sepse,'1')
	into STRICT   ie_versao_sepse_w
	from   parametro_medico
	where  cd_estabelecimento = obter_estabelecimento_ativo;

	select	count(*)
	into STRICT	qt_geral_w
	from	escala_sepse_item
	where	nr_seq_escala = nr_seq_escala_p
	and		ie_resultado = 'S'
	and		((ie_versao_sepse_w = '1' and nr_seq_atributo in (4,5,6,7,8,9,11))
	or (ie_versao_sepse_w = '2' and nr_seq_atributo in (47,48,49,50,54,55,56,75)));

	open C01;
	loop
	fetch C01 into
		nr_seq_mentor_w,
		qt_susp_w,
		qt_grave_w,
		ie_regra_sepse_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (qt_susp_w > 0) and (qt_geral_w >= qt_susp_w) and (ie_regra_sepse_w <> 'HSA') then
			ie_retorno_w := 1;
		end if;

		select	max(ie_tipo_evolucao)
		into STRICT	ie_tipo_evolucao_w
		from	usuario
		where	nm_usuario = wheb_usuario_pck.get_nm_usuario;

		if (ie_tipo_evolucao_w = '1') then
			open C02;
			loop
			fetch C02 into
				ie_pessoa_destino_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				if (ie_pessoa_destino_w = '4') then
					select	count(*)
					into STRICT	qt_var_w
					from	escala_sepse_item
					where	nr_seq_escala = nr_seq_escala_p
					and		ie_resultado = 'S'
					and		((ie_versao_sepse_w = '1' and nr_seq_atributo in (12,13,14,15,16,17,18,19,20,21,22,23,24,25,26))
					or (ie_versao_sepse_w = '2' and nr_seq_atributo in (41,42,51,59,60,61,62,65,66,72,76,77)));

					if (qt_var_w > 0) and (qt_var_w >= qt_grave_w) then
						ie_retorno_w := 2;
					end if;
				end if;

				end;
			end loop;
			close C02;
		end if;

		end;
	end loop;
	close C01;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_fase_lib_sepse (nr_seq_escala_p bigint) FROM PUBLIC;
