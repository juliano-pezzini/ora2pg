-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION oft_obter_form_consulta ( nr_seq_consulta_p bigint) RETURNS bigint AS $body$
DECLARE



nm_usuario_w		      usuario.nm_usuario%TYPE := wheb_usuario_pck.get_nm_usuario;
nr_sequencia_w		      oft_consulta_formulario.nr_sequencia%TYPE;
nr_sequencia_ww	      oft_consulta_formulario.nr_sequencia%TYPE;
dt_liberacao_w		      oft_consulta_formulario.dt_liberacao%TYPE;
dt_inativacao_w	      oft_consulta_formulario.dt_inativacao%TYPE;
dt_inativacao_ww	      oft_consulta_formulario.dt_inativacao%TYPE;
nr_seq_tipo_consulta_w  oft_consulta.nr_seq_tipo_consulta%type;
ie_encontrou_w		      varchar(1) := 'N';

c01 CURSOR FOR
	SELECT 	nr_sequencia,
				dt_liberacao,
				dt_inativacao
	FROM   	oft_consulta_formulario
	WHERE  	nr_seq_consulta	=  nr_seq_consulta_p
   and      nr_seq_regra_form =  oft_obter_formulario(nr_seq_tipo_consulta_w)
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR nm_usuario	= nm_usuario_w)
	ORDER BY dt_liberacao, nr_sequencia;


BEGIN


select   max(nr_seq_tipo_consulta)
into STRICT     nr_seq_tipo_consulta_w
from     oft_consulta
where    nr_sequencia = nr_seq_consulta_p;


ie_encontrou_w := 'N';
OPEN C01;
LOOP
FETCH C01 INTO
	nr_sequencia_w,
	dt_liberacao_w,
	dt_inativacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
	IF (coalesce(dt_liberacao_w::text, '') = '') THEN
		nr_sequencia_ww 	:= nr_sequencia_w;
		ie_encontrou_w		:= 'S';
	END IF;
	IF (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') AND (coalesce(dt_inativacao_w::text, '') = '') THEN
		nr_sequencia_ww := nr_sequencia_w;
		ie_encontrou_w		:= 'S';
	END IF;

	IF (ie_encontrou_w = 'N') AND (dt_inativacao_w IS NOT NULL AND dt_inativacao_w::text <> '') AND ((coalesce(dt_inativacao_ww::text, '') = '') OR (dt_inativacao_w > dt_inativacao_ww)) THEN
		nr_sequencia_ww 	:= nr_sequencia_w;
		dt_inativacao_ww 	:= dt_inativacao_w;
	END IF;

	END;
END LOOP;
CLOSE C01;

RETURN nr_sequencia_ww;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION oft_obter_form_consulta ( nr_seq_consulta_p bigint) FROM PUBLIC;

