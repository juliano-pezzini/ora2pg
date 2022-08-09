-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_bonific_obito_seg ( nr_seq_segurado_p bigint, nr_seq_regra_obito_p bigint, dt_rescisao_titular_p timestamp, qt_anos_validade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_motivo_rescisao_w	bigint;
qt_validade_contrato_w		bigint;
nr_seq_bonificacao_w		bigint;
dt_fim_vigencia_bonif_w		timestamp;
qt_registros_w			bigint;
nr_seq_resc_prog_gerada_w	bigint;
dt_rescisao_benef_w		timestamp;
nr_seq_causa_rescisao_w		pls_causa_rescisao.nr_sequencia%type;
nr_seq_sca_seguro_w		pls_plano.nr_sequencia%type;


BEGIN

select	nr_seq_motivo_rescisao,
	CASE WHEN qt_anos_validade_p=0 THEN qt_anos_validade_p WHEN coalesce(qt_anos_validade_p::text, '') = '' THEN qt_validade_contrato  ELSE qt_anos_validade_p END ,
	nr_seq_bonificacao,
	nr_seq_causa_rescisao,
	nr_seq_sca
into STRICT	nr_seq_motivo_rescisao_w,
	qt_validade_contrato_w,
	nr_seq_bonificacao_w,
	nr_seq_causa_rescisao_w,
	nr_seq_sca_seguro_w
from	pls_sca_regra_obito
where	nr_sequencia	= nr_seq_regra_obito_p;

--Gravar a rescisao programada
if (nr_seq_motivo_rescisao_w IS NOT NULL AND nr_seq_motivo_rescisao_w::text <> '') and (qt_validade_contrato_w IS NOT NULL AND qt_validade_contrato_w::text <> '') then
	nr_seq_resc_prog_gerada_w := pls_gerar_rescisao_programada(	null, null, nr_seq_segurado_p, nr_seq_motivo_rescisao_w, qt_validade_contrato_w, dt_rescisao_titular_p, 'PJ', 'N', wheb_mensagem_pck.get_texto(1106517), nm_usuario_p, null, null, 0, null, 'S', nr_seq_resc_prog_gerada_w, nr_seq_causa_rescisao_w);
end if;

--Gravar a bonificacao de beneficio
if (nr_seq_bonificacao_w IS NOT NULL AND nr_seq_bonificacao_w::text <> '') then
	
	select	max(dt_rescisao)
	into STRICT	dt_rescisao_benef_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_p;
	
	if (coalesce(dt_rescisao_benef_w::text, '') = '' or ((dt_rescisao_benef_w IS NOT NULL AND dt_rescisao_benef_w::text <> '') and dt_rescisao_benef_w > clock_timestamp())) then
		
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_bonificacao_vinculo
		where	nr_seq_segurado		= nr_seq_segurado_p
		and	nr_seq_bonificacao	= nr_seq_bonificacao_w;	
		
		if (qt_registros_w = 0) then
			select	max(dt_rescisao)
			into STRICT	dt_fim_vigencia_bonif_w
			from	pls_rescisao_contrato
			where	nr_seq_segurado	= nr_seq_segurado_p
			and	ie_situacao	= 'A';
			
			insert	into pls_bonificacao_vinculo(	nr_sequencia, dt_atualizacao,nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_segurado, nr_seq_bonificacao, dt_inicio_vigencia, dt_fim_vigencia,
				nr_seq_sca_seguro_obito )
			values (	nextval('pls_bonificacao_vinculo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				nr_seq_segurado_p,nr_seq_bonificacao_w,dt_rescisao_titular_p,dt_fim_vigencia_bonif_w,
				nr_seq_sca_seguro_w );
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_bonific_obito_seg ( nr_seq_segurado_p bigint, nr_seq_regra_obito_p bigint, dt_rescisao_titular_p timestamp, qt_anos_validade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
