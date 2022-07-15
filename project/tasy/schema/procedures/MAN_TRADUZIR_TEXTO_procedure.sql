-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_traduzir_texto ( ds_texto_p text, nm_usuario_p text, cd_expressao_p INOUT text, ds_expressao_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_expressao_w		dic_expressao.cd_expressao%type;
ds_expressao_br_w	dic_expressao.ds_expressao_br%type;
ds_retorno_w		varchar(4000);
ds_glossario_w		varchar(4000);


BEGIN
begin
CALL abortar_se_base_wheb();

select	max(a.cd_expressao)
into STRICT	cd_expressao_w
from	dic_expressao	a
where	a.ds_expressao_br	= ds_texto_p;

if (coalesce(cd_expressao_w::text, '') = '') then
	-- Tirei porque a váriavel que recebe o DS_TEXTO_P é de 2000
	--Obter_valor_Dinamico_bv('select	max(a.cd_expressao) '||
	--			'from	dic_expressao@whebl02_orcl a '||
	--			'where	a.ds_expressao_br	= :ds_exp_estagio_p','ds_exp_estagio_p=' || ds_texto_p, cd_expressao_w);
	cd_expressao_w := Obter_valor_Dinamico('select	max(a.cd_expressao) '||
						 'from		dic_expressao@whebl02_orcl a '||
						 'where		a.ds_expressao_br	= ' || CHR(39) || ds_texto_p || CHR(39), cd_expressao_w);

	if (coalesce(cd_expressao_w::text, '') = '') or (cd_expressao_w = '0') then
		cd_expressao_w := Obter_valor_Dinamico_bv('select	dic_expressao_seq.nextval@whebl02_orcl '||
					'from	dual ', null, cd_expressao_w);

		ds_glossario_w	:= ' ';

		--if	(cd_expressao_w <> '0') then
		CALL Exec_Sql_Dinamico_bv('MAN_TRADUZIR_TEXTO -  CD_EXPRESSAO_W: ' || cd_expressao_w,
					'insert into dic_expressao@whebl02_orcl '||
					'		(nm_usuario, '||
					'		nm_usuario_nrec, ' ||
					'		dt_atualizacao, ' ||
					'		dt_atualizacao_nrec, ' ||
					'		cd_expressao, ' ||
					'		ds_glossario, ' ||
					'		ds_expressao_br) ' ||
					'	values	(:nm_usuario_p, ' ||
					'		:nm_usuario_p, ' ||
					'		sysdate, ' ||
					'		sysdate, ' ||
					'		:cd_expressao_p, ' ||
					'		:ds_glossario_p, ' ||
					'		:ds_texto_p) ',
					'nm_usuario_p=' || nm_usuario_p || ';' ||
					'nm_usuario_p=' || nm_usuario_p || ';' ||
					'cd_expressao_p=' || cd_expressao_w || ';' ||
					'ds_glossario_p=' || ds_glossario_w || ';' ||
					'ds_texto_p=' || ds_texto_p);
		--end if;
		/* if	(cd_expressao_w is null) or
			(cd_expressao_w = '0') then
			select	dic_expressao_seq.nextval
			into	cd_expressao_w
			from	dual;
		end if; */
	end if;

	insert into dic_expressao(nm_usuario,
		nm_usuario_nrec,
		dt_atualizacao,
		dt_atualizacao_nrec,
		cd_expressao,
		ds_glossario,
		ds_expressao_br)
	values (nm_usuario_p,
		nm_usuario_p,
		clock_timestamp(),
		clock_timestamp(),
		cd_expressao_w,
		' ',
		ds_texto_p);
end if;
exception
when others then
	null;
end;

cd_expressao_p	:= cd_expressao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_traduzir_texto ( ds_texto_p text, nm_usuario_p text, cd_expressao_p INOUT text, ds_expressao_p INOUT text) FROM PUBLIC;

