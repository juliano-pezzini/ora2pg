-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_preco_tuss_cbhpm ( cd_edicao_amb_p bigint, cd_procedimento_p bigint, nm_usuario_p text, ie_origem_proced_p bigint, qt_filme_p bigint, nr_auxiliares_p bigint, nr_incidencia_p bigint, qt_porte_anestesico_p bigint, dt_inicio_vigencia_p timestamp, cd_porte_p text, tx_porte_p bigint, qt_uco_p bigint) AS $body$
DECLARE


ie_valor_nulo_w		varchar(15) := 'N';


BEGIN

ie_valor_nulo_w	:= coalesce(obter_valor_param_usuario(705,3,obter_perfil_ativo,nm_usuario_p,coalesce(wheb_usuario_pck.get_cd_estabelecimento,0)),'N');

if (cd_edicao_amb_p IS NOT NULL AND cd_edicao_amb_p::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	begin
		insert into preco_tuss(	cd_edicao_amb,
	 				cd_procedimento,
	 				dt_atualizacao,
	 				dt_atualizacao_nrec,
	 				dt_inicio_vigencia,
	 				ie_origem_proced,
	 				ie_situacao,
	 				nm_usuario,
	 				nm_usuario_nrec,
	 				nr_porte_anest_cbhpm,
	 				qt_filme_cbhpm,
					nr_auxiliares_cbhpm,
	 				qt_incidencia_cbhpm,
					cd_porte_cbhpm,
					tx_porte,
					qt_uco,
	 				nr_sequencia           )
		values (		cd_edicao_amb_p,
                                        cd_procedimento_p,
                                        clock_timestamp(),
                                        clock_timestamp(),
                                        dt_inicio_vigencia_p,
                                        ie_origem_proced_p,
                                        'A',
                                        nm_usuario_p,
                                        nm_usuario_p,
                                        CASE WHEN ie_valor_nulo_w='N' THEN qt_porte_anestesico_p  ELSE CASE WHEN qt_porte_anestesico_p=0 THEN null  ELSE qt_porte_anestesico_p END  END ,
                                        CASE WHEN ie_valor_nulo_w='N' THEN qt_filme_p  ELSE CASE WHEN qt_filme_p=0 THEN null  ELSE qt_filme_p END  END ,
                                        CASE WHEN ie_valor_nulo_w='N' THEN nr_auxiliares_p  ELSE CASE WHEN nr_auxiliares_p=0 THEN null  ELSE nr_auxiliares_p END  END ,
                                        nr_incidencia_p,
					cd_porte_p,
					tx_porte_p,
					qt_uco_p,
                                        nextval('preco_tuss_seq')
			);
	end;
	
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_preco_tuss_cbhpm ( cd_edicao_amb_p bigint, cd_procedimento_p bigint, nm_usuario_p text, ie_origem_proced_p bigint, qt_filme_p bigint, nr_auxiliares_p bigint, nr_incidencia_p bigint, qt_porte_anestesico_p bigint, dt_inicio_vigencia_p timestamp, cd_porte_p text, tx_porte_p bigint, qt_uco_p bigint) FROM PUBLIC;
