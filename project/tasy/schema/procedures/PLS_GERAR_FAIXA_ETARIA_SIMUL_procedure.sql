-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_faixa_etaria_simul ( nr_seq_simulacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_idade_inicial_w		integer;
qt_idade_final_w		integer;
qt_registros_w			bigint;
nr_seq_simul_perfil_w		pls_simulacao_perfil.nr_sequencia%type;
nr_seq_parametro_com_w		pls_simulacao_preco.nr_seq_parametro_com%type;
nr_seq_faixa_etaria_w		pls_faixa_etaria.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	qt_idade_inicial,
		qt_idade_final
	from	pls_faixa_etaria_item
	where	nr_seq_faixa_etaria = nr_seq_faixa_etaria_w;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_simulacao_perfil
	where	nr_seq_simulacao = nr_seq_simulacao_p;


BEGIN

begin
select	nr_seq_parametro_com
into STRICT	nr_seq_parametro_com_w
from	pls_simulacao_preco
where	nr_sequencia	= nr_seq_simulacao_p;
exception
	when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(262236, 'NR_SEQ_SIMULACAO=' || nr_seq_simulacao_p);
	/* Mensagem: Não foi possível gerar a tabela de faixa etária da simulação de preço! (Simulação NR_SEQ_SIMULACAO) */

end;

if (nr_seq_parametro_com_w IS NOT NULL AND nr_seq_parametro_com_w::text <> '') then
	select	max(nr_seq_faixa_etaria)
	into STRICT	nr_seq_faixa_etaria_w
	from	pls_simul_regra_param
	where	nr_sequencia = nr_seq_parametro_com_w;
end if;

select	count(*)
into STRICT	qt_registros_w
from	pls_simulpreco_coletivo
where	nr_seq_simulacao	= nr_seq_simulacao_p;

if (qt_registros_w > 0) then
	delete	FROM pls_simulpreco_coletivo
	where	nr_seq_simulacao	= nr_seq_simulacao_p;
end if;

open C02;
loop
fetch C02 into
	nr_seq_simul_perfil_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	open C01;
	loop
	fetch C01 into
		qt_idade_inicial_w,
		qt_idade_final_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		insert into pls_simulpreco_coletivo(nr_sequencia,
			nr_seq_simulacao,
			qt_idade_inicial,
			qt_idade_final,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			qt_beneficiario,
			nr_seq_simul_perfil)
		values (	nextval('pls_simulpreco_coletivo_seq'),
			nr_seq_simulacao_p,
			qt_idade_inicial_w,
			qt_idade_final_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			0,
			nr_seq_simul_perfil_w);
		end;
	end loop;
	close C01;

	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_faixa_etaria_simul ( nr_seq_simulacao_p bigint, nm_usuario_p text) FROM PUBLIC;
