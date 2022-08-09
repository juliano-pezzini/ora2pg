-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_tabela (( cd_tabela_servico_p bigint, dt_vigencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) is cd_tabela_servico_w smallint) RETURNS bigint AS $body$
DECLARE


nr_seq_retorno_w	integer := 1;
qt_reg_w		integer  := 1;


BEGIN

while qt_reg_w != 0 loop
	begin
	nr_seq_retorno_w:= nr_seq_retorno_w+1;
	select	count(1)
	into STRICT	qt_reg_w
	from	tabela_servico
	where 	cd_tabela_servico = nr_seq_retorno_w;

	end;
end loop;

return	nr_seq_retorno_w;
end;

begin

cd_tabela_servico_w := pls_seq_tabela;

insert into tabela_servico(	cd_tabela_servico,
				cd_estabelecimento,
				ds_tabela_servico,
				ie_situacao,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_tiss_tabela,
				ie_hosp_pls)
			(SELECT	cd_tabela_servico_w,
				cd_estabelecimento_p,
				'Cópia ' || ds_tabela_servico,
				ie_situacao,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_tiss_tabela,
				ie_hosp_pls
			from	tabela_servico
			where	cd_tabela_servico	= cd_tabela_servico_p
			and	cd_estabelecimento	= cd_estabelecimento_p);


open C01;
loop
fetch C01 into
	cd_estabelecimento_w,
	cd_tabela_servico_ww,
	cd_procedimento_w,
	dt_inicio_vigencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into preco_servico(	cd_estabelecimento,
					cd_tabela_servico,
					cd_procedimento,
					dt_inicio_vigencia,
					vl_servico,
					cd_moeda,
					dt_atualizacao,
					nm_usuario,
					ie_origem_proced,
					cd_unidade_medida,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					dt_inativacao,
					dt_vigencia_final)
				(SELECT	cd_estabelecimento,
					cd_tabela_servico_w,
					cd_procedimento,
					CASE WHEN coalesce(dt_vigencia_p::text, '') = '' THEN dt_inicio_vigencia  ELSE to_date(dt_vigencia_p,'dd/mm/yy') END ,
					vl_servico,
					cd_moeda,
					clock_timestamp(),
					nm_usuario_p,
					ie_origem_proced,
					cd_unidade_medida,
					clock_timestamp(),
					nm_usuario_p,
					dt_inativacao,
					dt_vigencia_final
				from	preco_servico
				where	cd_estabelecimento	= cd_estabelecimento_w
				and	cd_tabela_servico	= cd_tabela_servico_ww
				and	cd_procedimento		= cd_procedimento_w
				and	dt_inicio_vigencia	= dt_inicio_vigencia_w);

	end;
end loop;
close C01;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_tabela (( cd_tabela_servico_p bigint, dt_vigencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) is cd_tabela_servico_w smallint) FROM PUBLIC;
