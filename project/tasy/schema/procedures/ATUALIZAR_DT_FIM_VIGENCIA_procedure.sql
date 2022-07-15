-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dt_fim_vigencia ( dt_fim_p timestamp, ds_observacao_p text, nm_usuario_p text, nr_sequencia_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Aderir a data de fim de vigência e observação na classificação da pessoa física
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
	InformarFimVigenciaClassifWDLG (Cadastro de funcionários)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update	pessoa_classif
	set	dt_final_vigencia	= dt_fim_p,
		ds_observacao		= ds_observacao_p,
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_sequencia_p;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dt_fim_vigencia ( dt_fim_p timestamp, ds_observacao_p text, nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;

