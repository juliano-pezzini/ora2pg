-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_liberar_agrupamento ( nr_seq_agrupamento_p bigint, nr_seq_inutilizacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_producao_w	bigint;
qt_volume_w		smallint := 0;
nr_seq_derivado_w	bigint;
nr_sangue_w		varchar(20);
dt_vencimento_w		timestamp;
ie_tipo_sangue_w	varchar(2);
ie_fator_rh_w		varchar(1);
					
C01 CURSOR FOR
	SELECT	nr_seq_producao
	from	san_agrupamento_derivado
	where	nr_seq_agrupamento = nr_seq_agrupamento_p
	order by 1;
					

BEGIN

if (nr_seq_agrupamento_p IS NOT NULL AND nr_seq_agrupamento_p::text <> '') then

	open C01;
	loop
	fetch C01 into	
		nr_seq_producao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		select	coalesce(qt_volume,0) + qt_volume_w
		into STRICT	qt_volume_w
		from	san_producao
		where	nr_sequencia = nr_seq_producao_w;
		
		-- Inutilizar os hemocomponentes agrupados
		CALL inutilizar_hemocomp_producao(nr_seq_producao_w, nr_seq_inutilizacao_p, 'AGRUPAMENTO_TS', nm_usuario_p);
		
		end;
	end loop;
	close C01;

	select	nr_seq_derivado,
		nr_sangue,
		dt_vencimento,
		ie_tipo_sangue,
		ie_fator_rh
	into STRICT	nr_seq_derivado_w,
		nr_sangue_w,
		dt_vencimento_w,
		ie_tipo_sangue_w,
		ie_fator_rh_w
	from	san_agrupamento
	where	nr_sequencia = nr_seq_agrupamento_p;
	
	--Criar uma nova bolsa
	insert into san_producao(	
		nr_sequencia,
		nr_seq_derivado,
		dt_producao,
		cd_pf_realizou,
		dt_vencimento,
		nr_sangue,
		ie_irradiado,
		ie_lavado,
		ie_filtrado,
		ie_aliquotado,
		ie_aferese,
		dt_atualizacao,
		nm_usuario,
		qt_volume,
		nr_seq_agrupamento,
		dt_liberacao,
		nm_usuario_lib,
		ie_tipo_sangue,
		ie_fator_rh,
		cd_estabelecimento)
	values (	nextval('san_producao_seq'),
		nr_seq_derivado_w,
		clock_timestamp(),
		obter_pf_usuario(nm_usuario_p,'C'),
		dt_vencimento_w,
		nr_sangue_w,
		'N',
		'N',
		'N',
		'N',
		'N',
		clock_timestamp(),
		nm_usuario_p,
		qt_volume_w,
		nr_seq_agrupamento_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_tipo_sangue_w,
		ie_fator_rh_w,
		wheb_usuario_pck.get_cd_estabelecimento);
		
	update	san_agrupamento
	set	dt_liberacao = clock_timestamp(),
		nm_usuario_lib = nm_usuario_p
	where	nr_sequencia = nr_seq_agrupamento_p;

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_liberar_agrupamento ( nr_seq_agrupamento_p bigint, nr_seq_inutilizacao_p bigint, nm_usuario_p text) FROM PUBLIC;
